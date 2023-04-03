//
//  TransactionType.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation

enum TransactionType: String{
    case income = "INCOME"
    case expense = "EXPENSE"
    
    
    var title: String{
        switch self {
        case .income: return "income"
        case .expense: return "expense"
        }
    }
}
