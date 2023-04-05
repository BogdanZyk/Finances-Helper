//
//  CoreDataManager.swift
//  Splitify
//
//  Created by Bogdan Zykov on 28.03.2023.
//

import Foundation
import CoreData

struct CoreDataManager {
    
    //let groupStorage: GroupStorage
    let mainContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext) {
        self.mainContext = mainContext
       //self.groupStorage = GroupStorage(context: mainContext)
    }
    
}

//MARK: - Account
extension CoreDataManager{
    
    
    func updateAccount(account: AccountEntity){
        AccountEntity.updateAccount(for: account)
    }
    
    func createAccount(title: String, currencyCode: String, balance: Double, members: Set<UserEntity>) -> AccountEntity{
        AccountEntity.create(title: title, currencyCode: currencyCode, balance: balance, members: members, context: mainContext)
    }

}


//MARK: - User
extension CoreDataManager{
    
    private func createUserDefault() -> UserEntity{
        let user = UserEntity(context: mainContext)
        user.id = UUID().uuidString
        user.name = "Admin"
        mainContext.saveContext()
        return user
    }
    
    func getCurrentUser(id: String) -> UserEntity{
        let request = UserEntity.request(for: id)
        do {
            let result = try mainContext.fetch(request)
            if let user = result.first {
                return user
            }
        } catch {
            print(error.localizedDescription)
        }
        return createUserDefault()
    }
}

////MARK: -  Group logic
//extension CoreDataManager{
//
//    func fetchGroups(){
//        groupStorage.fetchGroups()
////        let fetchRequest = GroupEntity.request()
////
////        do {
////            let foods = try mainContext.fetch(fetchRequest)
////            return foods
////        } catch let error {
////            print("Failed to fetch FoodEntity: \(error)")
////        }
////        return []
//    }
//
//    func createGroup(title: String, currencyCode: String, colorType: Int16,  members: Set<UserEntity>){
//        GroupEntity.create(title: title, members: members, currencyCode: currencyCode, colorType: colorType, context: mainContext)
//    }
//
//    func updateGroup(group: GroupEntity, title: String, currencyCode: String, colorType: Int16,  members: Set<UserEntity>){
//        GroupEntity.update(group, title: title, members: members, currencyCode: currencyCode, colorType: colorType)
//    }
//}
//
//
////MARK: - User logic
//extension CoreDataManager{
//
//    func createUser(name: String) -> UserEntity{
//        UserEntity.create(name: name, context: mainContext)
//    }
//
//    func fetchUsers() -> [UserEntity]{
//        let fetchRequest = UserEntity.request()
//        do {
//            let foods = try mainContext.fetch(fetchRequest)
//            return foods
//        } catch let error {
//            print("Failed to fetch FoodEntity: \(error)")
//        }
//        return []
//    }
//}
//
//
////MARK: - Debt logic
//extension CoreDataManager{
//
//    func createDebt(groupId: String, creditor: UserEntity, debtor: UserEntity, amount: Double) -> DebtEntity{
//        DebtEntity.create(groupId: groupId, creditor: creditor, debtor: debtor, amount: amount, context: mainContext)
//    }
//}
//
//
////MARK: - Transaction logic
//extension CoreDataManager{
//
//    func createTransaction(title: String, creator: UserEntity, debts: Set<DebtEntity>, group: GroupEntity, amount: Double){
//        TransactionEntity.create(title: title, creator: creator, debts: debts, group: group, amount: amount, context: mainContext)
//    }
//
//    func updateTransaction(_ item: TransactionEntity, title: String, creator: UserEntity, debts: Set<DebtEntity>, amount: Double){
//        TransactionEntity.update(item, title: title, creator: creator, debts: debts, amount: amount, context: mainContext)
//    }
//
//    func remove(_ item: TransactionEntity){
//        TransactionEntity.remove(item)
//    }
//}
