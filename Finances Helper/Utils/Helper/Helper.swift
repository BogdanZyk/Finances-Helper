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
    

   static func getChartData(total: Double, transactions: [TransactionEntity]) -> [ChartData]{
        let chartData = transactions.compactMap({$0.chartData})
        var mergeData = Helper.mergeChartDataValues(chartData)
        
        for i in mergeData.indices {
            let percentage = (mergeData[i].value / total)
            mergeData[i].slicePercent =  (i == 0 ? 0.0 : mergeData[i - 1].slicePercent) + percentage
        }
        return mergeData
    }
}


extension Array where Element == TransactionEntity{
    
    func groupTransactionsByCategory() -> [TransactionList] {
        var transactionDict = [String: [TransactionEntity]]()
        
        // Group transactions by categoryId
        for transaction in self {
            guard let categoryId = transaction.category?.id else { continue }
            if transactionDict[categoryId] != nil {
                transactionDict[categoryId]?.append(transaction)
            } else {
                transactionDict[categoryId] = [transaction]
            }
        }
        
        // Create transactionList for each categoryId
        var transactionList = [TransactionList]()
        
        for (categoryId, transactionArray) in transactionDict {
            let totalAmount = transactionArray.reduce(0.0) { $0 + $1.amount }
            let transactionListObj = TransactionList(date: transactionArray[0].createAt, categoryId: categoryId, categoryTitle: transactionArray[0].category?.title ?? "", totalAmount: totalAmount)
            transactionList.append(transactionListObj)
        }
        
        return transactionList
    }
}

struct TransactionList: Identifiable{
    var date: Date?
    var categoryId: String
    var categoryTitle: String
    var totalAmount: Double
    
    var id: String { categoryId }
}
