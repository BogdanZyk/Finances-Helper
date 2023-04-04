//
//  RootView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct RootView: View {
    @State var transactionFullScreen: TransactionType?
    @EnvironmentObject var rootVM: RootViewModel    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                statsDonatView
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32){
                        transactionList
                    }
                    .padding()
                    .padding(.top)
                }
            }
            .navigationBarHidden(true)
            .overlay(alignment: .bottom) {
                transactionButtons
            }
            .fullScreenCover(item: $transactionFullScreen) { type in
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
    
    
    private var statsDonatView: some View{
        StatsView(rootVM: rootVM)
            .padding(.horizontal)
    }
    
    @ViewBuilder
    private var transactionList: some View{
        CategoryTagsView(rootVM: rootVM)
        LazyVStack(alignment: .leading, spacing: 16) {
            let chankedTransactions = Helper.groupTransactionsByDate(rootVM.transactions)
            ForEach(chankedTransactions.indices, id: \.self) { index in
                if let date = chankedTransactions[index].first?.createAt?.toFriedlyDate{
                    Text(date)
                        .font(.headline.bold())
                    ForEach(chankedTransactions[index]) { transaction in
                        VStack {
                            HStack{
                                Text(transaction.category?.title ?? "no category")
                                Spacer()
                                Text(transaction.friendlyAmount)
                            }
                            Divider()
                        }
                        .onLongPressGesture {
                            TransactionEntity.remove(transaction)
                        }
                    }
                }
            }
        }
    }
    
    private var transactionButtons: some View{
        HStack(spacing: 30){
            Button {
                transactionFullScreen = .expense
            } label: {
                Image(systemName: "minus")
                    .imageScale(.large)
                    .frame(width: 60, height: 60)
                    .background(Color.blue, in: Circle())
            }
            Button {
                transactionFullScreen = .income
            } label: {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .frame(width: 60, height: 60)
                    .background(Color.blue, in: Circle())
                    
            }
        }
        .foregroundColor(.white)
        .padding()
    }
    
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
