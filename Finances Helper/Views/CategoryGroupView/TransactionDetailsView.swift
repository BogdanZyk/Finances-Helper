//
//  TransactionDetailsView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 05.04.2023.
//

import SwiftUI

struct TransactionDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var transaction: TransactionEntity
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            labelView(title: "Amount", value: transaction.friendlyAmount)
            labelView(title: "Creator", value: transaction.created?.name ?? "")
            labelView(title: "Category", value: transaction.category?.title ?? "No category")
            labelView(title: "Date", value: transaction.createAt?.formatted(date: .abbreviated, time: .omitted) ?? "")
            labelView(title: "Note", value: transaction.note ?? "")
            Spacer()
        }
        .hLeading()
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Transaction details")
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    TransactionEntity.remove(transaction)
                    dismiss()
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct TransactionDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TransactionDetailsView(transaction: dev.transactions.first!)
        }
    }
}

extension TransactionDetailsView{
    
    private func labelView(title: String, value: String) -> some View{
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline.weight(.medium))
        }
    }
    
}
