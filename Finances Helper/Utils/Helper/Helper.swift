//
//  Helper.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 03.04.2023.
//

import Foundation

final class Helper{
    
    static func mergeChartDataValues(_ chartDataArray: [ChartData]) -> [ChartData] {
        var mergedDataArray = [ChartData]()
        
        for data in chartDataArray {
            if let index = mergedDataArray.firstIndex(where: {$0.id == data.id}) {
                mergedDataArray[index].value += data.value
            } else {
                mergedDataArray.append(data)
            }
        }
        return mergedDataArray
    }
    
    
    
    static func groupTransactionsByDate(_ transactions: [TransactionEntity]) -> [[TransactionEntity]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var groupedTransactions: [[TransactionEntity]] = []
        var currentDateTransactions: [TransactionEntity] = []
        var prevDate: String? = nil
        
        for transaction in transactions {
            let dateString = dateFormatter.string(from: transaction.createAt ?? .now)
            
            if dateString != prevDate {
                if !currentDateTransactions.isEmpty {
                    groupedTransactions.append(currentDateTransactions)
                }
                currentDateTransactions.removeAll()
            }
            
            currentDateTransactions.append(transaction)
            prevDate = dateString
        }
        if !currentDateTransactions.isEmpty {
            groupedTransactions.append(currentDateTransactions)
        }
        return groupedTransactions
    }
}
