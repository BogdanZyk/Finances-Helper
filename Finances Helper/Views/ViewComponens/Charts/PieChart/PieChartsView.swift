//
//  PieChartsView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct PieChartView: View {
    let values: [SliceValue]
    let names: [SliceCategory]
    let formatter: (Double) -> String
    
    var backgroundColor: Color
    
    var widthFraction: CGFloat
    var innerRadiusFraction: CGFloat
    
    @State private var activeIndex: Int = -1
    @State private var categoryId: String = ""
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, {$1.amount + $0})
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for value in values {
            let degrees: Double = value.amount * 360 / sum
            tempSlices.append(PieSliceData(categoryId: value.categoryId, startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: String(format: "%.0f%%", value.amount * 100 / sum), color: names.first(where: {$0.id == value.categoryId})?.color ?? .secondary))
            endDeg += degrees
        }
        return tempSlices
    }
    
    public init(values: [SliceValue], names: [SliceCategory], formatter: @escaping (Double) -> String, backgroundColor: Color = Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0), widthFraction: CGFloat = 0.75, innerRadiusFraction: CGFloat = 0.60){
        self.values = values
        self.names = names
        self.formatter = formatter
        
        self.backgroundColor = backgroundColor
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack{
                ZStack{
                    ForEach(0..<self.values.count, id: \.self){ i in
                        PieSlice(pieSliceData: self.slices[i])
                            .scaleEffect(self.activeIndex == i ? 1.03 : 1)
                            .animation(Animation.spring(), value: activeIndex)
                    }
                    .frame(width: widthFraction * geometry.size.width, height: widthFraction * geometry.size.width)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let radius = 0.5 * widthFraction * geometry.size.width
                                let diff = CGPoint(x: value.location.x - radius, y: radius - value.location.y)
                                let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                                if (dist > radius || dist < radius * innerRadiusFraction) {
                                    self.activeIndex = -1
                                    self.categoryId = ""
                                    return
                                }
                                var radians = Double(atan2(diff.x, diff.y))
                                if (radians < 0) {
                                    radians = 2 * Double.pi + radians
                                }
                                
                                for (i, slice) in slices.enumerated() {
                                    if (radians < slice.endAngle.radians) {
                                        self.activeIndex = i
                                        self.categoryId = slice.categoryId
                                        break
                                    }
                                }
                            }
                            .onEnded { value in
                                self.activeIndex = -1
                                self.categoryId = ""
                            }
                    )
                    Circle()
                        .fill(self.backgroundColor)
                        .frame(width: widthFraction * geometry.size.width * innerRadiusFraction, height: widthFraction * geometry.size.width * innerRadiusFraction)
                    
                    VStack {
                        Text(names.first(where: {$0.id == categoryId})?.title ?? "Total")
                            .font(.title)
                            .foregroundColor(Color.gray)
                        Text(self.formatter(self.activeIndex == -1 ? values.reduce(0, {$0 + $1.amount}) : values[self.activeIndex].amount))
                            .font(.title)
                    }
                    
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .foregroundColor(Color.white)
        }
    }
}


struct PieChartView_Previews: PreviewProvider {
    
    static let values: [SliceValue] = [.init(categoryId: "2", amount: 300), .init(categoryId: "1", amount: 500)]
    static let categories: [SliceCategory] = [.init(id: "1", title: "Category 1", color: .red), .init(id: "2", title: "Category 2", color: .green)]
    static var previews: some View {
        PieChartView(values: values, names: categories, formatter: {value in value.treeNumString + " $"})
            .background(Color.black)
           // .frame(width: 400, height: 400)
    }
}



struct SliceCategory{
    var id: String
    var title: String
    var color: Color
}


struct SliceValue{
    var categoryId: String
    var amount: Double
}