//
//  ProfileView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 05.04.2023.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var profileMV: ProfileViewModel
    @ObservedObject var rootVM: RootViewModel
    
    init(rootVM: RootViewModel) {
        self._profileMV = StateObject(wrappedValue: ProfileViewModel(context: rootVM.coreDataManager.mainContext))
        self.rootVM = rootVM
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(profileMV.accounts) { account in
                        NavigationLink {
                            CreateAccountView(rootVM: rootVM, account: account)
                        } label: {
                            HStack {
                                Circle()
                                    .fill(account.wrappedColor)
                                    .frame(width: 20, height: 20)
                                Text(account.title ?? "")
                                Spacer()
                                Text(account.friedlyBalance)
                                    .font(.headline)
                            }
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 5)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(rootVM: RootViewModel(context: dev.viewContext))
    }
}
