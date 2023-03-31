//
//  RootView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var rootVM: RootViewModel    
    var body: some View {
        VStack(spacing: 32){
            Text(rootVM.selectedDate.formatted(date: .abbreviated, time: .omitted))
                .font(.headline.bold())
            
            Spacer()
        }
        .padding()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RootView()
                .environmentObject(RootViewModel(context: dev.viewContext))
        }
    }
}
