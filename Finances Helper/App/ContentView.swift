//
//  ContentView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var rootVM: RootViewModel
    var body: some View {
        RootView()
            .environmentObject(rootVM)
            .preferredColorScheme(.light)
            .fullScreenCover(isPresented: $rootVM.showCreateAccoutView) {
                NavigationStack{
                    CreateAccountView(rootVM: rootVM, hiddenClose: true)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RootViewModel(context: dev.viewContext))
    }
}
