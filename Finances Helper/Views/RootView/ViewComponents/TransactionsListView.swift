//
//  TransactionsListView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 04.04.2023.
//

import SwiftUI

struct TransactionsListView: View {
    var transactions: [TransactionEntity]
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 16) {
            let chankedTransactions = Helper.groupTransactionsByDate(transactions)
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
}

struct TarnsactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsListView(transactions: dev.transactions)
    }
}
