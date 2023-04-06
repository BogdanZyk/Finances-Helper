//
//  MainSectionView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 06.04.2023.
//

import SwiftUI

struct MainSectionView: View {
//    @State var offset: CGFloat = 0
    @Binding var isExpandStats: Bool
    @ObservedObject var rootVM: RootViewModel
    let chartData: [ChartData]
    var body: some View {
        VStack(spacing: 0) {
            StatsView(isExpand: $isExpandStats, rootVM: rootVM, chartData: chartData)
                .padding(.horizontal)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32){
                    TransactionsListView(rootVM: rootVM, chartData: chartData)
                }
                .padding()
                .offset(coordinateSpace: .named("List")) { offset in
                    if offset <= -1 {
                        isExpandStats = true
                    }
                    if isExpandStats && offset > 1{
                        isExpandStats = false
                    }
                }
            }
            .coordinateSpace(name: "List")
        }
    }
}

struct MainSectionView_Previews: PreviewProvider {
    static var previews: some View {
        MainSectionView(isExpandStats: .constant(false), rootVM: .init(context: dev.viewContext), chartData: ChartData.sample)
    }
}
