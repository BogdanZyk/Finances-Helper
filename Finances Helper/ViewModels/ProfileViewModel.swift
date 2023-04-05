//
//  ProfileViewModel.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 05.04.2023.
//

import Foundation
import CoreData
import Combine

final class ProfileViewModel: ObservableObject{
    
    @Published var accounts = [AccountEntity]()
    @Published var user: UserEntity?
    
    private var cancellable = Set<AnyCancellable>()
    let accountStore: AccountStore
    let userService: UserService
    
    init(context: NSManagedObjectContext){
        self.accountStore = AccountStore(context: context)
        self.userService = UserService(context: context)
        
        startAccountsSubs()
        fetchAccounts()
    }
    
    
    private func fetchAccounts(){
        accountStore.fetch()
    }
    
    private func startAccountsSubs(){
        accountStore.accounts
            .dropFirst()
            .sink { accounts in
                self.accounts = accounts
            }
            .store(in: &cancellable)
    }
    
    func removeAccount(_ item: AccountEntity){
        AccountEntity.remove(item)
    }
    
}
