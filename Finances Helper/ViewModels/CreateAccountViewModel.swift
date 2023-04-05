//
//  CreateAccountViewModel.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 05.04.2023.
//

import Foundation
import SwiftUI
import CoreData

final class CreateAccountViewModel: ObservableObject{
    
    @Published var title: String = ""
    @Published var balance: Double = 0.0
    @Published var color: Color = .red
    @Published var currencyCode: String = Locale.current.currency?.identifier ?? "USD"
    let isEditMode: Bool
    let coreDataManager: CoreDataManager
    let userService: UserService
    var editedAccount: AccountEntity?
    
    init(context: NSManagedObjectContext, account: AccountEntity?){
        
        self.coreDataManager = CoreDataManager(mainContext: context)
        self.userService = UserService(context: context)
        if let account{
            title = account.title ?? ""
            balance = account.balance
            color = account.wrappedColor
            currencyCode = account.currencyCode ?? "USD"
            isEditMode = true
            editedAccount = account
            return
        }
        
        isEditMode = false
    }
    
    func save(onCreate: @escaping (String) -> Void){
        if isEditMode{
            update()
        }else{
            createAccount(onCreate)
        }
    }
    
    func removeAccount(){
        guard let editedAccount else {return}
        AccountEntity.remove(editedAccount)
    }
    
    private func createAccount(_ onCreate: @escaping (String) -> Void){
        guard let user = userService.currentUser else { return }
        let newAccount = coreDataManager.createAccount(title: title, currencyCode: currencyCode, balance: balance, members: Set([user]))
        onCreate(newAccount.id ?? "")
    }
    
    
    private func update(){
        guard let editedAccount else {return}
        
        editedAccount.title = title
        editedAccount.balance = balance
        editedAccount.color = color.toHex()
        editedAccount.currencyCode = currencyCode
        
        coreDataManager.updateAccount(account: editedAccount)
    }
    
}
