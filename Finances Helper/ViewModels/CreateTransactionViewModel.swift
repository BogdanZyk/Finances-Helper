//
//  CreateTransactionViewModel.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation

class CreateTransactionViewModel: ObservableObject{
    
    
    @Published var note: String = ""
    @Published var amount: Double = 0
    
    
    
//    func create(type: TransactionType, date: Date, account: AccountEntity){
//        TransactionEntity.create(amount: amount, createAt: date, type: type, created: <#T##UserEntity#>, account: <#T##AccountEntity#>, category: <#T##CategoryEntity#>, subcategory: <#T##SubcategoryEntity?#>, note: <#T##String?#>, context: <#T##NSManagedObjectContext#>)
//    }
}
