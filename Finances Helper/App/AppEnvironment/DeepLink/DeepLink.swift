//
//  DeepLink.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 06.04.2023.
//

import Foundation

enum DeepLink: Equatable {

    case openOrder(String)
    case product(String)
    case tab
    case profile
    
    
    static func getLinkType(value: String, type: String) -> Self{
        switch type{
        case "order": return .openOrder(value)
        default: return .tab
        }
    }
    
}
