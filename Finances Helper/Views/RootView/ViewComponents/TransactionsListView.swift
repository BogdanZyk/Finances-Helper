//
//  TransactionsListView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 04.04.2023.
//

import SwiftUI

struct TransactionsListView: View {
    @EnvironmentObject var rootVM: RootViewModel
    var chartData: [ChartData]
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            ForEach(chartData) { group in
                
                NavigationLink {
                    CategoryGroupView(chartData: group, rootVM: rootVM)
                } label: {
                    HStack(spacing: 20){
                        Text(group.title)
                            .font(.subheadline.weight(.medium))
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(group.color, in: Capsule())
                        Spacer()
                        Text("\(Int(group.persentage * 100))%")
                            .foregroundColor(.secondary)
                        Text(group.value.toCurrency(symbol: group.cyrrencySymbol))
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5)
                }
            }
        }
    }
}

struct TarnsactionListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TransactionsListView(chartData: ChartData.sample)
        }
        .environmentObject(RootViewModel(context: dev.viewContext))
    }
}
