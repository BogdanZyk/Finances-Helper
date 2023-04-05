//
//  Helper.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 03.04.2023.
//

import Foundation
import SwiftUI

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
    
    
    

    

   static func getChartData(total: Double, transactions: [TransactionEntity]) -> [ChartData]{
        let chartData = transactions.compactMap({$0.chartData})
        var mergeData = Helper.mergeChartDataValues(chartData)
        
        for i in mergeData.indices {
            let percentage = (mergeData[i].value / total)
            mergeData[i].persentage = percentage
            mergeData[i].slicePercent =  (i == 0 ? 0.0 : mergeData[i - 1].slicePercent) + percentage
        }
        return mergeData
    }
    
    static func showShareSheet(data: Any){
        UIActivityViewController(activityItems: [data], applicationActivities: nil).presentInKeyWindow()
    }
    
    static func generateCSV(_ transactions: [TransactionEntity]){
        guard let first = transactions.first else { return }
        
        let fileName = "\(Date.now.formatted(date: .complete, time: .omitted))" + "_\(first.wrappedType.title)" + ".csv"
        var csvText = "Date,Category,Amount,Currency,Note,Created\n"
        
        for csvModel in transactions {
            let row = "\"\(csvModel.createAt?.formatted(date: .numeric, time: .omitted) ?? "")\",\"\(csvModel.category?.title ?? "No Category")\",\"\(csvModel.amount.treeNumString)\",\"\(csvModel.currency?.code ?? "")\",\"\(csvModel.note ?? "")\",\"\(csvModel.created?.name ?? "No name")\"\n"
            csvText.append(row)
        }
        let path = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try csvText.write(to: path, atomically: true, encoding: String.Encoding.utf8)
            
            DispatchQueue.main.async{
                showShareSheet(data: path)
            }
        } catch { print(error.localizedDescription)}
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
            let transactionListObj = TransactionList(categoryId: categoryId, categoryTitle: transactionArray[0].category?.title ?? "", totalAmount: totalAmount)
            transactionList.append(transactionListObj)
        }
        
        return transactionList
    }
    
     func groupTransactionsByDate() -> [[TransactionEntity]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var groupedTransactions: [[TransactionEntity]] = []
        var currentDateTransactions: [TransactionEntity] = []
        var prevDate: String? = nil
        
        for transaction in self {
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

struct TransactionList: Identifiable{
    var categoryId: String
    var categoryTitle: String
    var totalAmount: Double
    
    var id: String { categoryId }
}


extension UIViewController {
    
    func presentInKeyWindow(animated: Bool = true, completion: (() -> Void)? = nil) {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController?.present(self, animated: animated, completion: completion)
    }
}
