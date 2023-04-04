//
//  DonutChart.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 03.04.2023.
//

import SwiftUI

struct DonutChart : View {
    var currencySymbol: String = "$"
    @Binding var chartData: [ChartData]
    @State private var selectedSlice = -1
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Circle()
                    .stroke(Color(.systemGray6), lineWidth: 45)
                ForEach(chartData.indices, id:\.self) { index in
                    Circle()
                        .trim(from: index == 0 ? 0.0 : chartData[index-1].slicePercent,
                              to: chartData[index].slicePercent)
                        .stroke(chartData[index].color,lineWidth: 40)
                        .gesture(
                            DragGesture(minimumDistance: 1)
                                .onChanged { value in
                                    selectedSlice = index
                                }
                                .onEnded{ _ in
                                    selectedSlice = -1
                                }
                        )
                        .scaleEffect(index == selectedSlice ? 1.05 : 1.0)
                        .animation(.spring(), value: selectedSlice)
                }
                centerLabel
                    .withoutAnimation()
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .animation(.spring().speed(0.5), value: chartData)
        }
    }
}

struct DonutChart_Previews: PreviewProvider {
    @State static var data = ChartData.sample
    static var previews: some View {
        DonutChart(chartData: $data)
            .frame(width: 200, height: 200)
    }
}


extension DonutChart{
        
    private var centerLabel: some View{
        VStack{
            if selectedSlice != -1 {
                Text(chartData[selectedSlice].title)
                    .foregroundColor(.secondary)
                Text(chartData[selectedSlice].value.toCurrency(symbol: currencySymbol))
            }else{
                Text("Total")
                Text(chartData.reduce(0.0) { $0 + $1.value }.toCurrency(symbol: currencySymbol))
            }
        }
        .font(.title3.bold())
    }
    
}




