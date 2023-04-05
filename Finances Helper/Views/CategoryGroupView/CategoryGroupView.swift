//
//  CategoryGroupView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 04.04.2023.
//

import SwiftUI

struct CategoryGroupView: View {
    let chartData: ChartData
    @ObservedObject var rootVM: RootViewModel
    var groupedTransactions: [[TransactionEntity]]{
        rootVM.statsData.getTransactions(for: rootVM.currentTab, categoryId: chartData.id)
            .groupTransactionsByDate()
    }
    var body: some View {
        VStack(spacing: 16) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 16, pinnedViews: .sectionHeaders) {
                    
                    ForEach(groupedTransactions.indices, id: \.self) { index in
                        if let date = groupedTransactions[index].first?.createAt?.toFriedlyDate{
                            Text(date)
                                .font(.subheadline.bold())
                                .foregroundColor(.secondary)
                            
                            ForEach(groupedTransactions[index]) { transaction in
                                rowView(transaction)
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            TransactionEntity.remove(transaction)
                                        } label: {
                                            Label("Remove", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(chartData.title)
                        .font(.subheadline.bold())
                    Text(chartData.value.toCurrency(symbol: chartData.cyrrencySymbol))
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
        .padding(.vertical, 10)
        .background(Color.white)
        .contentShape(Rectangle())
    }
    
}
