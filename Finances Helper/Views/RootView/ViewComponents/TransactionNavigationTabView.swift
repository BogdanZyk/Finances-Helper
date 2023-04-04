//
//  TransactionNavigationTabView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 04.04.2023.
//

import SwiftUI

struct TransactionNavigationTabView: View {
    @ObservedObject var rootVM: RootViewModel
    @Namespace var animation
    let types: [TransactionType] = [.expense, .income]
    var body: some View {
        HStack{
            ForEach(types) { type in
                Spacer()
                Text(type.title)
                    .foregroundColor(type == rootVM.currentTab ? Color.black : .secondary)
                    .font(.title2.bold())
                    .padding(.bottom, 5)
                    .padding(.horizontal, 5)
                    .overlay(alignment: .bottom) {
                        if type == rootVM.currentTab{
                            RoundedRectangle(cornerRadius: 2)
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "TRANSACTION_TAB", in: animation)
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            rootVM.currentTab = type
                        }
                    }
                Spacer()
            }
        }
    }
}

struct TransactionNavigationTabView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionNavigationTabView(rootVM: RootViewModel(context: dev.viewContext))
    }
}
