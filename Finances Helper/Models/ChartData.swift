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
}

extension ChartData {
    static var sample: [ChartData] {
        [ ChartData(color: .orange, slicePercent: 0.24, value: 350, title: "Udemy"),
          ChartData(color: .mint, value: 0.1, title: "Kindle"),
          ChartData(color: .teal, value: 0.25, title: "Medium"),
          ChartData(color: .pink, value: 0.39, title: "DevTechie")]
    }
}
