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
    var value : Double
    var title: String
}

extension ChartData {
    static var sample: [ChartData] {
        [ ChartData(color: .orange, value: 350, title: "Udemy"),
        ChartData(color: .mint, value: 154, title: "Kindle"),
          ChartData(color: .teal, value: 356, title: "Medium"),
          ChartData(color: .pink, value: 554, title: "DevTechie")]
    }
}
