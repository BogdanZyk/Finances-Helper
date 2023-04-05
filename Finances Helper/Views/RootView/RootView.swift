//
//  RootView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct RootView: View {
    @State var showAccountsList: Bool = false
    @EnvironmentObject var rootVM: RootViewModel    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let _ = rootVM.activeAccount{
                    navigationView
                    TabView(selection: $rootVM.currentTab) {
                        expenseSection
                            .tag(TransactionType.expense)
                        incomeSection
                            .tag(TransactionType.income)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }else{
                    ProgressView()
                }
            }
            .background(Color(.systemGray6))
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarHidden(true)
            .fullScreenCover(item: $rootVM.transactionFullScreen) { type in
                CreateTransactionView(type: type, rootVM: rootVM)
            }
            .sheet(isPresented: $rootVM.showDatePicker) {
                SheetDatePicker(rootVM: rootVM)
            }
            .sheet(isPresented: $showAccountsList) {
                AccountsListView(rootVM: rootVM)
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
            Button {
                showAccountsList.toggle()
            } label: {
                VStack(alignment: .center, spacing: 2) {
                    HStack {
                        Text(rootVM.activeAccount?.title ?? "")
                        Image(systemName: "arrowtriangle.down.fill")
                            .imageScale(.small)
                    }
                    .font(.callout)
                    .foregroundColor(.secondary)
                    Text(rootVM.activeAccount?.friedlyBalance ?? "")
                        .foregroundColor(rootVM.activeAccount?.balanceColor ?? .black)
                        .font(.title2.bold())
                }
            }
            .hCenter()
            .overlay(alignment: .trailing) {
                Button {
                    Helper.generateCSV(rootVM.statsData.expenseTransactions)
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
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
                    TransactionsListView(chartData: rootVM.statsData.expenseChartData)
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
                    TransactionsListView(chartData: rootVM.statsData.incomeChartData)
                }
                .padding()
                .padding(.top)
            }
        }
    }
    
}


