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
    
}
