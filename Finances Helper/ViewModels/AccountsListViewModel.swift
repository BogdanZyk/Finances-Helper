//
//  AccountsListViewModel.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 06.04.2023.
//

import Foundation
import CoreData

class AccountsListViewModel: ObservableObject{
    
    @Published var accounts = [AccountEntity]()
    
    private var cancelBag = CancelBag()
    let accountStore: ResourceStore<AccountEntity>

    
    init(context: NSManagedObjectContext){
        self.accountStore = ResourceStore(context: context)
        
        startAccountsSubs()
        fetchAccounts()
    }
    
    deinit{
        cancelBag.cancel()
    }
    
    private func fetchAccounts(){
        let request = AccountEntity.requestAll()
        accountStore.fetch(request)
    }
    
    private func startAccountsSubs(){
        accountStore.resources
            .dropFirst()
            .sink { accounts in
                self.accounts = accounts
            }
            .store(in: cancelBag)
    }
    
    func removeAccount(_ item: AccountEntity){
        AccountEntity.remove(item)
    }
    
}
