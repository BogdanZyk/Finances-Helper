//
//  CreateTransactionView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct CreateTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    let type: TransactionType
    @ObservedObject var rootVM: RootViewModel
    @StateObject private var viewModel:  CreateTransactionViewModel
    
    init(type: TransactionType, rootVM: RootViewModel){
        self.type = type
        self._rootVM = ObservedObject(wrappedValue: rootVM)
        self._viewModel = StateObject(wrappedValue: CreateTransactionViewModel(context: rootVM.coreDataManager.mainContext, transactionType: rootVM.currentTab))
    }
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 32){
                    dateButton
                    amountTextFiled
                    noteTextField
                    CategoriesTagsView(createVM: viewModel)
                }
                .padding()
            }
            .navigationTitle("New "+type.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.create(type: type, date: viewModel.date, forAccount: rootVM.account, created: rootVM.userService.currentUser)
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                    .disabled(viewModel.disabledSave)
                }
            }
            .overlay {
                createCategoryView
            }
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
        
        DatePicker(selection: $viewModel.date, displayedComponents: .date) {}
            .labelsHidden()
            .hLeading()
        
//        Button {
//
//        } label: {
//            Label(rootVM.selectedDate.toFriedlyDate, systemImage: "calendar")
//                .font(.headline.bold())
//                .foregroundColor(.black)
//        }
    }
    
    private var amountTextFiled: some View{
        HStack {
            NumberTextField(value: $viewModel.amount, promt: "", label: nil)
            Text(rootVM.account?.currency?.code ?? "USD")
                .font(.title3)
        }
    }
    
    private var noteTextField: some View{
        VStack {
            TextField("Note", text: $viewModel.note)
                .font(.title3.weight(.medium))
            Divider()
        }
    }
    
    private var createCategoryView: some View{
        Group{
            if let type = viewModel.createCategoryViewType{
                Color.secondary.opacity(0.3).ignoresSafeArea()
                    .onTapGesture {
                        viewModel.createCategoryViewType = nil
                    }
                CreateCategoryView(viewType: type, rootVM: rootVM, createVM: viewModel)
                    .padding()
            }
        }
        .animation(.easeInOut, value: viewModel.createCategoryViewType)
    }
}
