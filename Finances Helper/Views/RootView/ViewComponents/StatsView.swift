//
//  StatsView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var rootVM: RootViewModel
    
    var expensesTransactions: [(String, Double)]{
        let transactions = rootVM.transactions.filter({$0.wrappedType == .income})
        return (transactions.map({($0.category?.id ?? "", $0.amount)}))
    }
                       
//    var categores: [(String, String)]{
//
//    }
    var body: some View {
        
//        PieChartView(values: expensesTransactions, names: ["Rent", "Transport", "Education"], formatter: {$0.treeNumString + " $"})
        
        ProgressCircleView(persentage: 0.7, lineWidth: 30, circleOutline: .blue, circleTrack: Color(.systemGray3)) {
            VStack(alignment: .center){
                Text(rootVM.transactionsStats.incomeAmontStr)
                    .font(.title3.bold())
                    .foregroundColor(.green)
                Text(rootVM.transactionsStats.expenseAmountStr)
                    .font(.title3.bold())
                    .foregroundColor(.red)
            }
        }
        .frame(width: 200, height: 200)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(rootVM: RootViewModel(context: dev.viewContext))
    }
}
