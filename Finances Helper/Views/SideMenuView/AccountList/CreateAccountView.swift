//
//  CreateAccountView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 05.04.2023.
//

import SwiftUI
import CoreData

struct CreateAccountView: View {
    @ObservedObject var rootVM: RootViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showCurrencyView: Bool = false
    @StateObject var viewModel: CreateAccountViewModel
    private var hiddenClose: Bool
    
    init(rootVM: RootViewModel, account: AccountEntity? = nil, hiddenClose: Bool = false) {
        self.hiddenClose = hiddenClose
        self._viewModel = StateObject(wrappedValue: CreateAccountViewModel(context: rootVM.coreDataManager.mainContext, account: account))
        self.rootVM = rootVM
    }
    
    @State private var colors = (1...10).map({_ in Color.random})
    @State private var showAlert: Bool = false
    
    var isEditMode: Bool{
        viewModel.isEditMode
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 32){
                balanceSection
                balanceTitle
                colorSection
                inviteButton
                saveButton
                removeButton
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(isEditMode ? "Update" : "New") account")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !hiddenClose{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showCurrencyView) {
            CurrencyView(selectedCurrencyCode: $viewModel.currencyCode)
        }
        .alert("Account deletion", isPresented: $showAlert) {
            alertButtons
        } message: {
            Text("Are you sure you want to delete the account?")
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateAccountView(rootVM: RootViewModel(context: dev.viewContext), account: dev.accounts.first!)
        }
    }
}

extension CreateAccountView{
    
    
    private var balanceSection: some View{
        HStack{
            NumberTextField(value: $viewModel.balance, promt: "", label: nil)
            Button {
                showCurrencyView.toggle()
            } label: {
                Text(viewModel.currencyCode)
            }
            .disabled(isEditMode)
        }
        .frame(width: 200)
        .font(.title3)
    }
    
    private var balanceTitle: some View{
        VStack(alignment: .leading, spacing: 10) {
            Text("Account name")
                .font(.subheadline)
            TextField("Enter the account name", text: $viewModel.title)
                .font(.headline)
            Divider()
        }
    }
    
    private var colorSection: some View{
        VStack(alignment: .leading, spacing: 10) {
            Text("Color")
                .font(.subheadline)
            colorPicker
        }
    }
    
    private var inviteButton: some View{
        Button {
            
        } label: {
            Text("Invite users")
        }
        .hLeading()
    }
    
    private var saveButton: some View{
        Button {
            viewModel.save { id in
                rootVM.changeAccount(id)
            }
            dismiss()
        } label: {
            Text("Save")
                .padding(.vertical)
                .foregroundColor(.white)
                .font(.title3.weight(.medium))
                .hCenter()
                .background(Color.blue, in: Capsule())
        }
        .padding(.vertical)
    }
    
    private var colorPicker: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack{
                ForEach(colors, id: \.self){color in
                    Circle()
                        .fill(color)
                        .frame(width: 30, height: 30)
                        .scaleEffect(color == viewModel.color ? 1.2 : 1)
                        .opacity(color == viewModel.color ? 1 : 0.5)
                        .onTapGesture {
                            viewModel.color = color
                        }
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 50)
        .padding(.horizontal, -16)
    }
    
    @ViewBuilder
    private var removeButton: some View{
        if isEditMode{
            Button {
                showAlert.toggle()
            } label: {
                Text("Remove")
                    .foregroundColor(.red)
            }
        }
    }
    
    private var alertButtons: some View{
        Group{
            Button("Delete", role: .destructive) {
                viewModel.removeAccount()
                dismiss()
            }
        }
    }
}
