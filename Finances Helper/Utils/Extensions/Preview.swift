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
        
        
        let trans2 = TransactionEntity(context: context)
        trans2.id = UUID().uuidString
        trans2.createAt = Date.now
        trans2.amount = 600
        trans2.currencyCode = "RUB"
        trans2.type = TransactionType.expense.rawValue
        
        return [trans1, trans2]
    }

}
