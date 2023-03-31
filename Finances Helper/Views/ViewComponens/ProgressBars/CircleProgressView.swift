//
//  CircleProgressView.swift
//  FoodSecret
//
//  Created by Bogdan Zykov on 15.03.2023.
//

import SwiftUI


struct ProgressCircleView<Label: View>: View {
    var label: (() -> Label)?
    var persentage: CGFloat
    var lineWidth: CGFloat
    var circleOutline: Color = .green
    var circleTrack: Color = .gray
    
    
    init(persentage: CGFloat,
         lineWidth: CGFloat,
         circleOutline: Color = .green,
         circleTrack: Color = .gray,
         label: (() -> Label)? = nil) {
        
        self.label = label
        self.persentage = persentage
        self.lineWidth = lineWidth
        self.circleOutline = circleOutline
        self.circleTrack = circleTrack
    }
    
    var body: some View {
        ZStack{
            Circle()
                .stroke(style: .init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .fill(circleTrack)
            Circle()
                .trim(from: 0, to: persentage)
                .stroke(style: .init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .fill(circleOutline)
                .rotationEffect(.init(degrees: -90))
            if let label{
                label()
            }
        }
        .animation(.spring(response: 3), value: persentage)
    }
}


struct ProgressCircleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 60){
            ProgressCircleView(persentage: 0.5, lineWidth: 10) {
                Text("test")
            }
            .frame(width: 200, height: 200)
            ProgressCircleView(persentage: 0.25, lineWidth: 5) {
                Text("test2")
            }
            .frame(width: 200, height: 200)
        }
        
    }
}
