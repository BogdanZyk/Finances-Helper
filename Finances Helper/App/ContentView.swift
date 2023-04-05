//
//  ContentView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var rootVM = RootViewModel(context: PersistenceController.shared.viewContext)
    var body: some View {
        RootView()
            .environmentObject(rootVM)
            .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
