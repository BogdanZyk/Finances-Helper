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
    
    @Published private(set) var activeAccount: AccountEntity?
    @Published var showCreateAccoutView: Bool = false
    @Published var statsData = TransactionStatData()
    @Published var selectedCategory: CategoryEntity?
    @Published var currentTab: TransactionType = .expense
    @Published var timeFilter: TransactionTimeFilter = .day
    @Published var transactionFullScreen: TransactionType?
    @Published var showDatePicker: Bool = false
    
    let coreDataManager: CoreDataManager
    let transactionStore: TransactionStore
    let accountStore: AccountStore
    let userService: UserService
    private var cancellable = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext){
        
        userService = UserService(context: context)
        coreDataManager = CoreDataManager(mainContext: context)
        accountStore = AccountStore(context: context)
        transactionStore = TransactionStore(context: context)
    
        
        startSubsAccount()
    
        fetchAccount()
        
        startSubsTransaction()
        
        startDateSubsTransaction()
        
        fetchTransactions()
        
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

   
}


//MARK: - Transaction logic
extension RootViewModel{
    
    func fetchTransactions(){
        guard let start = timeFilter.date.start, let end = timeFilter.date.end, let datePredicate = NSPredicate.transactionPredicate(startDate: start, endDate: end, accountId: activeAccountId) else { return }
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
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { filter in
                self.fetchTransactions()
            }
            .store(in: &cancellable)
    }
    
    private func setTransactions(){
        self.statsData = .init(transactionStore.transactions.value)
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
       accountStore.fetch(id: activeAccountId)
    }
    
//    private func startOnChangeActiveAccount(){
//        activeAccountId
//
//            .sink { _ in
//                self.fetchAccount()
//                self.fetchTransactions()
//            }
//            .store(in: &cancellable)
//    }
    
    private func startSubsAccount(){
        accountStore.accounts
            .dropFirst()
            .sink { accounts in
                if let account = accounts.first{
                    self.activeAccount = account
                }else{
                    self.showCreateAccoutView = true
                }
                
            }
            .store(in: &cancellable)
    }
}
