//
//  TransactionEntity.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import CoreData

extension TransactionEntity{
    
    
    
    
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
        context.saveContext()
    }
    
    //NSPredicate.datePredicate(before: date.noon, after: date.dayAfter)
}


extension NSPredicate{
  static func datePredicate(before: Date, after: Date)-> Self? {
      NSPredicate(format: "createAt >= %@ AND createAt < %@", before as NSDate, after as NSDate) as? Self
    }
}



enum TransactionType: String{
    case income = "INCOME"
    case expense = "EXPENSE"
}
