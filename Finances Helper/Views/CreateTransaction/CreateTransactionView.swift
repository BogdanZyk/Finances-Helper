//
//  CreateTransactionView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct CreateTransactionView: View {
    @StateObject private var viewModel = CreateTransactionViewModel()
    let type: TransactionType
    @ObservedObject var rootVM: RootViewModel
    var body: some View {
        NavigationStack {
            VStack(spacing: 32){
                dateButton
                amountTextFiled
                Spacer()
            }
            .padding()
            .navigationTitle("New "+type.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CreateTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTransactionView(type: .income, rootVM: RootViewModel(context: dev.viewContext))
    }
}

extension CreateTransactionView{
    private var dateButton: some View{
        Button {
            
        } label: {
            Label(rootVM.selectedDate.toFriedlyDate, systemImage: "calendar")
                .font(.headline.bold())
                .foregroundColor(.black)
        }
    }
    
    private var amountTextFiled: some View{
        NumberTextField(value: $viewModel.amount, promt: "", label: nil)
    }
}
