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
        VStack{
            ForEach(rootVM.transactions) { transaction in
                Text("Amount")
                Text("\(Int(transaction.amount))")
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(RootViewModel(context: dev.viewContext))
    }
}
