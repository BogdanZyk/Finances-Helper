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
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32){
                StatsView(rootVM: rootVM)
                .hCenter()
                Spacer()
                allTransactionList
            }
            .padding()
            .padding(.top)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(rootVM.selectedDate.toFriedlyDate)
                    .font(.headline.bold())
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            transactionButtons
        }
        .fullScreenCover(item: $transactionFullScreen) { type in
            CreateTransactionView(type: type, rootVM: rootVM)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RootView()
                .environmentObject(RootViewModel(context: dev.viewContext))
        }
    }
}


extension RootView{
    
    @ViewBuilder
    private var allTransactionList: some View{
        VStack(alignment: .leading, spacing: 16) {
            ForEach(rootVM.transactions) { transaction in
                HStack{
                    Text(transaction.category?.title ?? "no category")
                    Spacer()
                    Text(transaction.friendlyAmount)
                }
                Divider()
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
}
