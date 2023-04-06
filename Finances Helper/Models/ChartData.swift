//
//  ChartData.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 03.04.2023.
//

import Foundation
import SwiftUI

struct ChartData: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var color : Color
    var slicePercent : CGFloat = 0.0
    var persentage: Double = 0.0
    var value : Double
    var title: String
    var type: TransactionType = .income
    var cyrrencySymbol: String = "$"
    
    var friendlyTotal: String{
        value.formattedWithAbbreviations(symbol: cyrrencySymbol)
    }
}

extension ChartData {
    static var sample: [ChartData] {
        [ ChartData(color: .orange, slicePercent: 0.2967032967032967, persentage: 0.2967032967032967, value: 405.0, title: "Udemy"),
          ChartData(color: .mint, slicePercent: 0.7069597069597069, persentage: 0.41025641025641024, value: 560.0, title: "Kindle"),
          ChartData(color: .teal, slicePercent: 1.0, persentage: 0.29304029304029305, value: 400.0, title: "Medium")]
    }
}

//
//[Finances_Helper.ChartData(id: "BD6FEE47-9EE5-417D-B899-C725FD4C838F", color: #D028DAFF, slicePercent: 0.2967032967032967, persentage: 0.2967032967032967, value: 405.0, title: "Test", type: Finances_Helper.TransactionType.expense, cyrrencySymbol: "₽"), Finances_Helper.ChartData(id: "02164EEE-21E4-41B8-A89E-7909DE76A203", color: #542E12FF, slicePercent: 0.7069597069597069, persentage: 0.41025641025641024, value: 560.0, title: "Test4", type: Finances_Helper.TransactionType.expense, cyrrencySymbol: "₽"), Finances_Helper.ChartData(id: "18B2D151-AE6D-42DA-B207-525A7BB2F63F", color: #65A8EFFF, slicePercent: 1.0, persentage: 0.29304029304029305, value: 400.0, title: "Test 2", type: Finances_Helper.TransactionType.expense, cyrrencySymbol: "₽")]
