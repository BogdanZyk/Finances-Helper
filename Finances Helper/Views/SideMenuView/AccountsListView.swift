//
//  AccountsListView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 05.04.2023.
//

import SwiftUI

struct AccountsListView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var profileMV: AccountsListViewModel
    @ObservedObject var rootVM: RootViewModel
    @State var createType: ScreenType?
    init(rootVM: RootViewModel) {
        self._profileMV = StateObject(wrappedValue: AccountsListViewModel(context: rootVM.coreDataManager.mainContext))
        self.rootVM = rootVM
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(profileMV.accounts) { account in
                    HStack {
                        Circle()
                            .fill(account.wrappedColor)
                            .frame(width: 20, height: 20)
                        Text(account.title ?? "")
                        Spacer()
                        Text(account.friedlyBalance)
                            .font(.headline)
                        Button {
                            createType = .edit(account)
                        } label: {
                            Text("Edit")
                                .font(.callout)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay{
                        if account.id == rootVM.activeAccountId{
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.blue, lineWidth: 2)
                        }
                    }
                    .shadow(color: .black.opacity(0.1), radius: 5)
                    .onTapGesture {
                        if let id = account.id{
                            rootVM.changeAccount(id)
                        }
                        dismiss()
                    }
                }
            }
            .padding()
            .padding(.bottom, 40)
        }
        .overlay(alignment: .bottom) {
            addButton
                .padding()
        }
        .navigationTitle("Accounts")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $createType) { type in
            Group{
                NavigationStack{
                    switch type{
                    case .new:
                        CreateAccountView(rootVM: rootVM)
                    case .edit(let account):
                        CreateAccountView(rootVM: rootVM, account: account)
                    }
                }
            }
        }
    }
}

struct BalansesView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsListView(rootVM: RootViewModel(context: dev.viewContext))
    }
}

extension AccountsListView{
    
    private var addButton: some View{
        Button {
            createType = .new
        } label: {
            Text("New account")
                .font(.title3.bold())
                .foregroundColor(.white)
                .padding()
                .hCenter()
                .background(Color.blue, in: Capsule())
        }

    }
    
    enum ScreenType: Identifiable{
        case new, edit(AccountEntity)
        
        var id: Int{
            switch self{
            case .new: return 0
            case .edit: return 1
            }
        }
    }
}
