//
//  Helper.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 03.04.2023.
//

import Foundation

final class Helper{
    
    static func mergeChartDataValues(_ chartDataArray: [ChartData]) -> [ChartData] {
        var mergedDataArray = [ChartData]()
        
        for data in chartDataArray {
            if let index = mergedDataArray.firstIndex(where: {$0.id == data.id}) {
                mergedDataArray[index].value += data.value
            } else {
                mergedDataArray.append(data)
            }
        }
        return mergedDataArray
    }
}
