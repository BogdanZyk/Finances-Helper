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




struct Currency: Identifiable {
    
    var id: String{ code }
    /// Returns the currency code. For example USD or EUD
    let code: String
    
    var name: String?
    
    /// Returns currency symbols. For example ["USD", "US$", "$"] for USD, ["RUB", "₽"] for RUB or ["₴", "UAH"] for UAH
    let symbols: [String]
    
    /// Returns shortest currency symbols. For example "$" for USD or "₽" for RUB
    var shortestSymbol: String {
        return symbols.min { $0.count < $1.count } ?? ""
    }
    
    /// Returns information about a currency by its code.
    static func currency(for code: String) -> Currency? {
        return cache[code]
    }
    
    // Global constants and variables are always computed lazily, in a similar manner to Lazy Stored Properties.
    static fileprivate var cache: [String: Currency] = { () -> [String: Currency] in
        var mapCurrencyCode2Symbols: [String: Set<String>] = [:]
        let currencyCodes = Set(Locale.commonISOCurrencyCodes)
        
        for localeId in Locale.availableIdentifiers {
            let locale = Locale(identifier: localeId)
            
            guard let currencyCode = locale.currency?.identifier, let currencySymbol = locale.currencySymbol else {
                continue
            }
            if currencyCode.contains(currencyCode) {
                mapCurrencyCode2Symbols[currencyCode, default: []].insert(currencySymbol)
            }
        }
        
        var mapCurrencyCode2Currency: [String: Currency] = [:]
        for (code, symbols) in mapCurrencyCode2Symbols {
            let name = Locale.current.localizedString(forCurrencyCode: code)
            mapCurrencyCode2Currency[code] = Currency(code: code, name: name, symbols: Array(symbols))
        }
        return mapCurrencyCode2Currency
    }()
    
    static func getAllCurrency() -> [Currency]{
        Locale.commonISOCurrencyCodes.compactMap({Currency.currency(for: $0)})
    }
    
    
    static var popularCurrency: [Currency]{
        let code = ["USD", "EUR", "GBR", "RUB", "UAH", "CNY", "JPY"]
        return code.compactMap({Currency.currency(for: $0)})
    }
}
