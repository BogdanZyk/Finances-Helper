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
