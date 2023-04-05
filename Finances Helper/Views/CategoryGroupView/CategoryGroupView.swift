//
//  CategoryGroupView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 04.04.2023.
//

import SwiftUI

struct CategoryGroupView: View {
    var chartData: ChartData
    @ObservedObject var rootVM: RootViewModel
    var groupedTransactions: [[TransactionEntity]]{
        rootVM.statsData.getTransactions(for: rootVM.currentTab, categoryId: chartData.id)
            .groupTransactionsByDate()
    }
    
    private var total: String{
        groupedTransactions.flatMap({$0}).reduce(0.0, {$0 + $1.amount}).toCurrency(symbol: chartData.cyrrencySymbol)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 16) {
                    
                    ForEach(groupedTransactions.indices, id: \.self) { index in
                        if let date = groupedTransactions[index].first?.createAt?.toFriedlyDate{
                            Text(date)
                                .font(.subheadline.bold())
                                .foregroundColor(.secondary)
                            
                            ForEach(groupedTransactions[index]) { transaction in
                                NavigationLink {
                                    TransactionDetailsView(transaction: transaction)
                                } label: {
                                    rowView(transaction)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(chartData.title)
                        .font(.subheadline.bold())
                    Text(total)
                        .font(.title3.bold())
                }
            }
        }
    }
}

struct CategoryGroupView_Previews: PreviewProvider {
    static let category = dev.category.first!
    static var previews: some View {
        NavigationStack {
            CategoryGroupView(chartData: ChartData(id: category.id ?? "", color: category.wrappedColor, value: 240, title: category.title ?? "", type: category.wrappedCategoryType, cyrrencySymbol: "$"), rootVM: RootViewModel(context: dev.viewContext))
        }
    }
}

extension CategoryGroupView{
    
    private func rowView(_ transaction: TransactionEntity) -> some View{
        VStack {
            HStack{
                VStack(alignment: .leading) {
                    Text(chartData.title)
                    Text(transaction.note ?? "")
                }
                Spacer()
                Text(transaction.friendlyAmount)
                    .font(.headline)
            }
            Divider()
        }
        .foregroundColor(.black)
        .background(Color.white)
    }
    
}
