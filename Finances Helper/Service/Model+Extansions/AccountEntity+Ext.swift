//
//  AccountEntity+Ext.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import CoreData

extension AccountEntity{
    
    

    
    
    static private func create(members: Set<UserEntity>, context: NSManagedObjectContext){
        let entity = AccountEntity(context: context)
        entity.id = UUID().uuidString
        entity.createAt = Date.now
        entity.currencyCodes = "USD RUB"
        entity.members = members as NSSet
        entity.categories = []
        entity.transactions = []
        
        context.saveContext()
    }
    
    
    
   static func createAccountIfNeeded(context: NSManagedObjectContext) {

        let fetchRequest = NSFetchRequest<AccountEntity>(entityName: "AccountEntity")
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: true)]

        do {
            let count = try context.count(for: fetchRequest)
            if count == 1 {
                return
            }else {
                let user = UserEntity.create(name: "Admin", context: context)
                AccountEntity.create(members: Set([user]), context: context)
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return
        }
    }
    
}
