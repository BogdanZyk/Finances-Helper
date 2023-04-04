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
    
    @Published private(set) var account: AccountEntity?
    @Published var statsData = TransactionStatData()
    @Published var selectedCategory: CategoryEntity?
    @Published var currentTab: TransactionType = .expense
    @Published var timeFilter: TransactionTimeFilter = .day
    @Published var transactionFullScreen: TransactionType?
    @Published var showDatePicker: Bool = false
    let coreDataManager: CoreDataManager
    let transactionStore: TransactionStore
    let userService: UserService
    private var cancellable = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext){
        
        userService = UserService(context: context)
        coreDataManager = CoreDataManager(mainContext: context)
        transactionStore = TransactionStore(context: context)
        
        createAndFetchAccount()
        
        startDateSubsTransaction()
        
        startSubsTransaction()
        
        //startCategorySubs()
    }
    
    
    func selectCategory(_ category: CategoryEntity){
        selectedCategory = category
    }
    

    func addTransaction(){
        self.transactionFullScreen = currentTab
    }
    
//    private func startCategorySubs(){
//        $selectedCategory
//            .sink { category in
//                guard let category, let id = category.id else {
//                    self.setTransactions()
//                    return
//                }
//                if category.isParent{
//                    self.transactions = self.transactions.filter({$0.category?.id == id})
//                }else{
//                    self.transactions = self.transactions.filter({$0.subcategoryId == id})
//                }
//                self.createChartData()
//            }
//            .store(in: &cancellable)
//    }

    private func createAndFetchAccount(){
        guard let user = userService.currentUser else { return }
        coreDataManager.createAccountIfNeeded(for: user)
        account = coreDataManager.fetchAccount()
    }
}


//MARK: - Transaction logic
extension RootViewModel{
    
    func fetchTransactionForDate(){
        guard let start = timeFilter.date.start, let end = timeFilter.date.end, let datePredicate = NSPredicate.datePredicate(startDate: start, endDate: end) else { return }
        transactionStore.fetch(for: datePredicate)
    }
    
    private func startSubsTransaction(){
        transactionStore.transactions
            .receive(on: DispatchQueue.main)
            .sink { transactions in
                self.statsData = .init(transactions)
            }
            .store(in: &cancellable)
    }
    
    private func startDateSubsTransaction(){
        $timeFilter
            .receive(on: DispatchQueue.main)
            .sink { filter in
                self.fetchTransactionForDate()
            }
            .store(in: &cancellable)
    }
    
    private func setTransactions(){
        self.statsData = .init(transactionStore.transactions.value)
    }
}
