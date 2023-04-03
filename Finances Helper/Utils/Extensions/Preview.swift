//
//  Preview.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//


import CoreData
import SwiftUI

extension PreviewProvider {
    
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    


    
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() { }
    
    
    let contreller = PersistenceController(inMemory: true)
    
    var viewContext: NSManagedObjectContext {
        
         
        _ = transactions
        
        
        return contreller.viewContext
     }
    
    var transactions: [TransactionEntity]{
        let context = contreller.viewContext
        let trans1 = TransactionEntity(context: context)
        trans1.id = UUID().uuidString
        trans1.createAt = Date.now
        trans1.amount = 1300
        trans1.currencyCode = "RUB"
        trans1.type = TransactionType.income.rawValue
        trans1.category = category[1]
        
        
        let trans2 = TransactionEntity(context: context)
        trans2.id = UUID().uuidString
        trans2.createAt = Date.now
        trans2.amount = 600
        trans2.currencyCode = "RUB"
        trans2.type = TransactionType.expense.rawValue
        trans2.category = category[0]
        
        return [trans1, trans2]
    }
    
    
    var category: [CategoryEntity]{
        let context = contreller.viewContext
        let category1 = CategoryEntity(context: context)
        category1.id = UUID().uuidString
        category1.title  = "Category 1"
        category1.color = "#E5B95A"
        
        let category2 = CategoryEntity(context: context)
        category2.id = UUID().uuidString
        category2.title  = "Category 2"
        category2.color = "#549BD0"
        
        return [category1, category2]
    }

}
