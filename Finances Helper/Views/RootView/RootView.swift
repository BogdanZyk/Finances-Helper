//
//  RootView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var rootVM: RootViewModel    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                navigationView
                TabView(selection: $rootVM.currentTab) {
                    expenseSection
                        .tag(TransactionType.expense)
                    incomeSection
                        .tag(TransactionType.income)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .background(Color(.systemGray6))
            .navigationBarHidden(true)
            .fullScreenCover(item: $rootVM.transactionFullScreen) { type in
                CreateTransactionView(type: type, rootVM: rootVM)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(RootViewModel(context: dev.viewContext))
        
    }
}

extension RootView{
    
    private var navigationView: some View{
        VStack(spacing: 16){
            TransactionNavigationTabView(rootVM: rootVM)
        }
        .padding(.horizontal)
    }
}


extension RootView{
    
    private var expenseSection: some View{
        VStack(spacing: 0) {
            StatsView(rootVM: rootVM, chartData: $rootVM.statsData.expenseChartData)
                .padding(.horizontal)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32){
                    TransactionsListView(transactions: rootVM.statsData.expenseTransactions)
                }
                .padding()
                .padding(.top)
            }
        }
    }
    
    private var incomeSection: some View{
        VStack(spacing: 0) {
            StatsView(rootVM: rootVM, chartData: $rootVM.statsData.incomeChartData)
                .padding(.horizontal)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32){
                    TransactionsListView(transactions: rootVM.statsData.incomeTransactions)
                }
                .padding()
                .padding(.top)
            }
        }
    }
    
}

extension RootView{
    
    private var dateMenuPicker: some View{
        Menu {
            ForEach(TransactionTimeFilter.allCases) { type in
                Button(type.title) {
                    rootVM.timeFilter = type
                    rootVM.fetchTransactionForDate()
                }
            }
        } label: {
            Text(rootVM.timeFilter.title)
        }

    }
}
