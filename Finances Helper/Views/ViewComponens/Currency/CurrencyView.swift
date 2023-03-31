//
//  CurrencyView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
import SwiftUI

struct CurrencyView: View {
    @Binding var selectedCurrencyCode: String
    @State private var search: String = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(popularSearchCurrencyResult) {
                        rowView($0)
                    }
                } header: {
                    Text("Popular")
                }
                
                Section {
                    ForEach(searchAllCurrencyResult) {
                        rowView($0)
                    }
                } header: {
                    Text("All Currency")
                }
                
            }
            .navigationTitle("Select currency")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.inset)
            .searchable(text: $search, placement: SearchFieldPlacement.navigationBarDrawer(displayMode: .always), prompt: Text("Search"))
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(selectedCurrencyCode: .constant(""))
    }
}

extension CurrencyView{
    
    private var searchAllCurrencyResult: [Currency]{
        if search.isEmpty{
            return allCurrencyList
        }else{
            return allCurrencyList.filter({$0.code.contains(search.uppercased())})
        }
    }
    
    private var popularSearchCurrencyResult: [Currency]{
        if search.isEmpty{
            return popularCurrency
        }else{
            return popularCurrency.filter({$0.code.contains(search.uppercased())})
        }
    }
    
    private var popularCurrency: [Currency]{
        Currency.popularCurrency
    }
    
    private var allCurrencyList: [Currency]{
        Currency.getAllCurrency()
    }
    
    private func rowView(_ currency: Currency) -> some View{
        Button {
            selectedCurrencyCode = currency.code
            dismiss()
        } label: {
            HStack {
                Text(currency.name ?? "")
                Spacer()
                Text(currency.code)
                Text("\(currency.shortestSymbol)")
            }
            .padding(.vertical, 6)
        }
    }
}





