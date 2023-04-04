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
    @Published var selectedCategory: CategoryEntity?
    @Published var chartData = [ChartData]()
    @Published var timeFilter: TransactionTimeFilter = .day
    let coreDataManager: CoreDataManager
    let trasactionStore: TransactionStore
    let userService: UserService
    private var cancellable = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext){
        
        userService = UserService(context: context)
        coreDataManager = CoreDataManager(mainContext: context)
        trasactionStore = TransactionStore(context: context)
        
        createAndFetchAccount()
        
        startDateSubsTransaction()
        
        startSubsTransaction()
        
        startCategorySubs()
    }
    
    
    func selectCategory(_ category: CategoryEntity){
        selectedCategory = category
    }
    

    
    private func startCategorySubs(){
        $selectedCategory
            .sink { category in
                guard let category, let id = category.id else {
                    self.setTransactions()
                    return
                }
                if category.isParent{
                    self.transactions = self.transactions.filter({$0.category?.id == id})
                }else{
                    self.transactions = self.transactions.filter({$0.subcategoryId == id})
                }
                self.createChartData()
            }
            .store(in: &cancellable)
    }

    private func createAndFetchAccount(){
        guard let user = userService.currentUser else { return }
        coreDataManager.createAccountIfNeeded(for: user)
        account = coreDataManager.fetchAccount()
    }
    
    private func createChartData(){
        
        let chartData = transactions.compactMap({$0.chartData}).filter({$0.type == .expense})
        var mergeData = Helper.mergeChartDataValues(chartData)
        let total: CGFloat = mergeData.reduce(0.0) { $0 + $1.value }
        for i in mergeData.indices {
            let percentage = (mergeData[i].value / total)
            mergeData[i].slicePercent =  (i == 0 ? 0.0 : mergeData[i - 1].slicePercent) + percentage
        }
        
        self.chartData = mergeData
    }
}


//MARK: - Transaction logic
extension RootViewModel{
    
    func fetchTransactionForDate(){
        guard let start = timeFilter.date.start, let end = timeFilter.date.end, let datePredicate = NSPredicate.datePredicate(startDate: start, endDate: end) else { return }
        trasactionStore.fetch(for: datePredicate)
    }
    
    private func startSubsTransaction(){
        trasactionStore.transactions
            .receive(on: DispatchQueue.main)
            .sink { transactions in
                self.transactions = transactions
                self.createChartData()
            }
            .store(in: &cancellable)
    }
    
    private func startDateSubsTransaction(){
        $timeFilter
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.fetchTransactionForDate()
            }
            .store(in: &cancellable)
    }
    
    private func setTransactions(){
        self.transactions = trasactionStore.transactions.value
        self.createChartData()
    }
}
