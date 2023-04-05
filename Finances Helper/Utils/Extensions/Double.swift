//
//  Double.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import Foundation
extension Double{
    
    
    var twoNumString: String {
        String(format: "%.1f", self)
    }
    
    
    var treeNumString: String{
        if self.truncatingRemainder(dividingBy: 1) == 0{
            return String(format: "%.0f", self)
        }else{
           return String(format: "%.2f", self)
        }
    }
    
    func calculatePercentage(for total: Double) -> CGFloat{
        if self >= total {return 1}
        return self / total
    }
    
    func toCurrency(symbol: String?) -> String{
        twoNumString + (symbol ?? "$")
    }
    
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations(symbol: String) -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.treeNumString
            return "\(sign)\(stringFormatted)Tr \(symbol)"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.treeNumString
            return "\(sign)\(stringFormatted)Bn \(symbol)"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.treeNumString
            return "\(sign)\(stringFormatted)M \(symbol)"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.treeNumString
            return "\(sign)\(stringFormatted)K \(symbol)"
        default:
            return self.toCurrency(symbol: symbol)
        }
    }
}
