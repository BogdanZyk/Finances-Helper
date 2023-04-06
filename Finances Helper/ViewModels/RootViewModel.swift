//
//  RootViewModel.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import CoreData
import Combine
import SwiftUI

final class RootViewModel: ObservableObject{
    
    @AppStorage("activeAccountId") var activeAccountId: String = ""
    @AppStorage("savedTimeFilter") var savedTimeFilter: String = ""
    
    @Published private(set) var activeAccount: AccountEntity?
    @Published private(set) var statsData = TransactionStatData()
    @Published var showSettingsView: Bool = false
    @Published var showCreateAccoutView: Bool = false
    @Published var selectedCategory: CategoryEntity?
    @Published var currentTab: TransactionType = .expense
    @Published var timeFilter: TransactionTimeFilter = .day
    @Published var transactionFullScreen: TransactionType?
    @Published var showDatePicker: Bool = false
    
    let coreDataManager: CoreDataManager
    let userService: UserService
    private let transactionStore: ResourceStore<TransactionEntity>
    private let accountStore: ResourceStore<AccountEntity>
    private var cancelBag = CancelBag()
    
    init(context: NSManagedObjectContext){
        userService = UserService(context: context)
        coreDataManager = CoreDataManager(mainContext: context)
        accountStore = ResourceStore(context: context)
        transactionStore = ResourceStore(context: context)
    
        startSubsAccount()
    
        fetchAccount()
        
        startSubsTransaction()
        
        startDateSubsTransaction()
        
        setTimeFilter()
        
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

    func generateCSV(){
        if currentTab == .expense{
            Helper.generateCSV(statsData.expenseTransactions)
        }else{
            Helper.generateCSV(statsData.incomeTransactions)
        }
    }
   
}


//MARK: - Transaction logic
extension RootViewModel{
    
    func fetchTransactions(){
        guard let start = timeFilter.date.start, let end = timeFilter.date.end, let predicate = NSPredicate.transactionPredicate(startDate: start, endDate: end, accountId: activeAccountId) else { return }
        let request = TransactionEntity.fetchRequest(for: predicate)
        transactionStore.fetch(request)
    }
    
    private func startSubsTransaction(){
        transactionStore.resources
            .receive(on: DispatchQueue.main)
            .sink { transactions in
                self.statsData = .init(transactions)
            }
            .store(in: cancelBag)
    }
    
    private func startDateSubsTransaction(){
        $timeFilter
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { filter in
                self.fetchTransactions()
                self.savedTimeFilter = filter.title
            }
            .store(in: cancelBag)
    }
    
    private func setTimeFilter(){
        timeFilter = TransactionTimeFilter.allCases.first(where: {$0.title == savedTimeFilter}) ?? .day
    }
}

//MARK: - Account logic
extension RootViewModel{
    
    
    func changeAccount(_ accountId: String){
        activeAccountId = accountId
        fetchAccount()
        fetchTransactions()
    }
    
    func fetchAccount(){
        let request = AccountEntity.request(for: activeAccountId)
       accountStore.fetch(request)
    }
        
    private func startSubsAccount(){
        accountStore.resources
            .dropFirst()
            .sink { accounts in
                if let account = accounts.first{
                    self.activeAccount = account
                }else{
                    self.showCreateAccoutView = true
                }
                
            }
            .store(in: cancelBag)
    }
}
