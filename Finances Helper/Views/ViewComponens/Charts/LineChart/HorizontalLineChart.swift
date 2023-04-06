//
//  HorizontalLineChart.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 06.04.2023.
//

import SwiftUI

struct HorizontalLineChart: View {
    let chartData: [ChartData]
    var currencySymbol: String{
        chartData.first?.cyrrencySymbol ?? ""
    }
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 16) {
                ZStack(alignment: .leading){
                    Rectangle()
                        .fill(Color(.systemGray5))
                    ForEach(chartData.reversed()) { chart in
                        Rectangle()
                            .fill(chart.color)
                            .frame(width: proxy.size.width * chart.slicePercent)
                    }
                }
                .frame(height: proxy.size.height / 3)
                .clipShape(Capsule())
                Group{
                    if chartData.isEmpty{
                        Text("0")
                    }else{
                        Text(chartData.reduce(0.0) { $0 + $1.value }.formattedWithAbbreviations(symbol: currencySymbol))
                    }
                }
                .font(.title3.weight(.medium))
                .withoutAnimation()
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .animation(.spring().speed(0.5), value: chartData)
    }
}

struct HorizontalLineChart_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalLineChart(chartData: ChartData.sample)
            .frame(height: 60)
            .padding()
    }
}
