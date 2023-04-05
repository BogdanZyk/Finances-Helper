//
//  AccountEntity+Ext.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import CoreData
import SwiftUI

extension AccountEntity{
    
    
    var friedlyBalance: String{
        balance.formattedWithAbbreviations(symbol: currencySymbol)
    }
    
    var currency: Currency?{
        Currency.currency(for: currencyCode ?? "USD")
    }
    
    var balanceColor: Color{
        balance > 0 ? .green : .red
    }
    
    var currencySymbol: String{
        currency?.shortestSymbol ?? "$"
    }
    
    var wrappedColor: Color{
        guard let color else { return .blue }
        return Color(hex: color)
    }
    
    static func create(title: String, currencyCode: String, balance: Double, members: Set<UserEntity>, context: NSManagedObjectContext) -> AccountEntity{
        let entity = AccountEntity(context: context)
        entity.id = UUID().uuidString
        entity.createAt = Date.now
        entity.title = title
        entity.currencyCode = currencyCode
        entity.balance = balance
        entity.members = members as NSSet
        entity.creatorId = members.first?.id ?? ""
        entity.transactions = []
        
        context.saveContext()
        
        return entity
    }
    
    static func updateAccount(for account: AccountEntity){
        guard let context = account.managedObjectContext else { return }
        context.saveContext()
    }
    
    static func requestAll() -> NSFetchRequest<AccountEntity>{
        let fetchRequest = NSFetchRequest<AccountEntity>(entityName: "AccountEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: true)]
        fetchRequest.propertiesToFetch = ["id", "currencyCode", "title", "balance"]
        return fetchRequest
    }
    
    static func request(for id: String) -> NSFetchRequest<AccountEntity>{
        let fetchRequest = NSFetchRequest<AccountEntity>(entityName: "AccountEntity")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.propertiesToFetch = ["id", "currencyCode", "title", "balance"]
        return fetchRequest
    }
    
    static func remove(_ item: AccountEntity){
        guard let context = item.managedObjectContext else { return }
        context.delete(item)
        context.saveContext()
    }
    
}
