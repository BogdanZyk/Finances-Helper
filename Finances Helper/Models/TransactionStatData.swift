//
//  TransactionStatData.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 04.04.2023.
//

import Foundation
import SwiftUI

struct TransactionStatData{
    
    var incomeTransactions = [TransactionEntity]()
    var expenseTransactions = [TransactionEntity]()
    var incomeTotal: Double
    var expenseTotal: Double
    var incomeChartData: [ChartData]
    var expenseChartData: [ChartData]
    
    init(_ transactions: [TransactionEntity] = [TransactionEntity]()) {
        self.incomeTransactions = transactions.filter({$0.wrappedType == .income})
        self.expenseTransactions = transactions.filter({$0.wrappedType == .expense})
        self.incomeTotal = incomeTransactions.reduce(0.0) { $0 + $1.amount }
        self.expenseTotal = expenseTransactions.reduce(0.0) { $0 + $1.amount }
        self.expenseChartData = Helper.getChartData(total: expenseTotal, transactions: expenseTransactions)
        self.incomeChartData = Helper.getChartData(total: incomeTotal, transactions: incomeTransactions)
        
    }

    func getTransactions(for type: TransactionType, categoryId: String) -> [TransactionEntity]{
        if type == .expense{
            return expenseTransactions.filter({$0.category?.id == categoryId})
        }else{
            return incomeTransactions.filter({$0.category?.id == categoryId})
        }
    }
}
