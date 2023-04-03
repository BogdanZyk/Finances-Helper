//
//  RootViewModel.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import CoreData
import Combine

final class RootViewModel: ObservableObject{
    
    @Published var account: AccountEntity?
    @Published var transactions = [TransactionEntity]()
    @Published var chartData = [ChartData]()
    @Published var selectedDate: Date = .now
    @Published var categories = [CategoryEntity]()
    let coreDataManager: CoreDataManager
    let trasactionStore: TransactionStore
    let categoriesStore: CategoriesStore
    private var cancellable = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext){
        
        coreDataManager = CoreDataManager(mainContext: context)
        trasactionStore = TransactionStore(context: context)
        categoriesStore = CategoriesStore(context: context)
        
        createAndFetchAccount()
        
        fetchTransactionForDate()
        categoriesStore.fetch()
        
        startSubsTransaction()
        startSubsCategories()
    }
    
    
    private func startSubsTransaction(){
        trasactionStore.transactions
            .sink { transactions in
                self.transactions = transactions
                self.createChartData()
            }
            .store(in: &cancellable)
    }
    
    private func startSubsCategories(){
        categoriesStore.categories
            .sink { categories in
                self.categories = categories
            }
            .store(in: &cancellable)
    }
    
    private func createAndFetchAccount(){
        coreDataManager.createAccountIfNeeded()
        account = coreDataManager.fetchAccount()
    }
    
    func fetchTransactionForDate(){
       guard let datePredicate = NSPredicate.datePredicate(before: selectedDate.noon, after: selectedDate.dayAfter) else { return }
        trasactionStore.fetch(for: datePredicate)
    }
    
    private func createChartData(){
        
        let chartData = transactions.compactMap({$0.chartData})
        var mergeData = Helper.mergeChartDataValues(chartData)
        let total : CGFloat = mergeData.reduce(0.0) { $0 + $1.value }
        for i in mergeData.indices {
            let percentage = (mergeData[i].value / total)
            mergeData[i].slicePercent =  (i == 0 ? 0.0 : mergeData[i - 1].slicePercent) + percentage
        }
        
        self.chartData = mergeData
    }
    
//    private func createTransactionStats(){
//        let res = transactions.reduce(into: (0.0, 0.0)) { partialResult, entity in
//            guard let type = entity.type else { return }
//            switch TransactionType(rawValue: type){
//            case.expense:
//                partialResult.1 += entity.amount
//            case .income:
//                partialResult.0 += entity.amount
//            case .none: break
//            }
//        }
//        self.transactionsStats = .init(incomeAmont: res.0, expenseAmount: res.1)
//    }
}


struct TransactionStats {
    
    var incomeAmont: Double = 0
    var expenseAmount: Double = 0
    
    var incomeAmontStr: String{
        incomeAmont.treeNumString + " $"
    }
    
    var expenseAmountStr: String{
        "-\(expenseAmount.treeNumString + " $")"
    }
    
    var total: Double{
      return expenseAmount - incomeAmont
    }
}
