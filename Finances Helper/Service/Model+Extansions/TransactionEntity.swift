//
//  TransactionEntity.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import CoreData
import SwiftUI

extension TransactionEntity{
    
    
    var wrappedType: TransactionType{
        .init(rawValue: type ?? "INCOME") ?? .income
    }
    
    var friendlyAmount: String{
        amount.twoNumString + " \(currency?.shortestSymbol ?? "$")"
    }
    
    var currency: Currency?{
        Currency.currency(for: currencyCode ?? "USD")
    }
    
    var chartData: ChartData?{
        if wrappedType == .income, let id = category?.id, let categoryTitle = category?.title{
          return ChartData(id: id, color: Color.random, value: amount, title: categoryTitle)
        }
        return nil
    }
    
    var sliceValue: SliceValue?{
        if wrappedType == .income, let id = category?.id{
            return .init(categoryId: id, amount: amount)
        }
        return nil
    }
    
    static func fetchRequest(for predicate: NSPredicate) -> NSFetchRequest<TransactionEntity> {
        let request = NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: true)]
        let datePredicate = predicate
        request.predicate = datePredicate
        return request
    }
    
    
    static func create(amount: Double,
                       createAt: Date,
                       type: TransactionType,
                       created: UserEntity,
                       account: AccountEntity,
                       category: CategoryEntity,
                       subcategory: SubcategoryEntity?,
                       note: String?,
                       context: NSManagedObjectContext){
        let entity = TransactionEntity(context: context)
        entity.id = UUID().uuidString
        entity.amount = amount
        entity.createAt = createAt
        entity.type = type.rawValue
        entity.created = created
        entity.category = category
        entity.subcategory = subcategory
        entity.forAccount = account
        entity.note = note
        context.saveContext()
    }
    
    //NSPredicate.datePredicate(before: date.noon, after: date.dayAfter)
}


extension NSPredicate{
  static func datePredicate(before: Date, after: Date)-> Self? {
      NSPredicate(format: "createAt >= %@ AND createAt < %@", before as NSDate, after as NSDate) as? Self
    }
}



