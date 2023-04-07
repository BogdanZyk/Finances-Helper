//
//  StatsView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct StatsView: View {
    @State private var showLine: Bool = false
    @Binding var isExpand: Bool
    @Namespace var animation
    @ObservedObject var rootVM: RootViewModel
    var chartData: [ChartData]
    var body: some View {
        ZStack(alignment: .top){
            ZStack(alignment: .center){
                if showLine{
                    HorizontalLineChart(chartData: chartData)
                        .frame(height: 60)
                        .matchedGeometryEffect(id: "CHART", in: animation)
                        .onTapGesture {
                            isExpand.toggle()
                        }
                        .transition(.scale.combined(with: .opacity))
                }else{
                    DonutChart(chartData: chartData)
                        .frame(height: 200)
                        .padding(.vertical, 26)
                        .matchedGeometryEffect(id: "CHART", in: animation)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.top, 90)
            .padding([.bottom, .horizontal])
            
            VStack(spacing: 10) {
                datePickerButtons
                dateTitle
            }
            .hCenter()
            .padding([.horizontal, .top])
            .background(Color.white)
        }
        .hCenter()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5)
        .overlay(alignment: .bottomTrailing) {
            Button {
                rootVM.addTransaction()
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .imageScale(.large)
                    .padding()
                    .background(Color.blue, in: Circle())
            }
            
            .scaleEffect(showLine ? 0.7 : 1)
            .padding(showLine ? 5 : 16)
        }
        .onChange(of: isExpand) { expand in
            withAnimation(.easeInOut(duration: 0.3)) {
                showLine = expand
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color(.systemGray6)
            StatsView(isExpand: .constant(false), rootVM: RootViewModel(context: dev.viewContext), chartData: ChartData.sample)
                .padding()
        }
    }
}

extension StatsView{
    
    private var dateTitle: some View{
        Text(rootVM.timeFilter.navTitle ?? "")
            .font(.subheadline.bold())
    }
    
    private var datePickerButtons: some View{
        HStack(spacing: 15) {
            ForEach(TransactionTimeFilter.allCases) { type in
                labelView(type)
                    .onTapGesture {
                        rootVM.timeFilter = type
                    }
            }
            labelView(TransactionTimeFilter.select(.now, .now))
                .onTapGesture {
                    rootVM.showDatePicker.toggle()
                }
        }
        .animation(.spring(), value: rootVM.timeFilter)
    }
    
    private func labelView(_ type: TransactionTimeFilter) -> some View{
        Text(type.title)
            .font(.headline)
            .foregroundColor(rootVM.timeFilter.id == type.id ? Color.black : .secondary)
            .padding(.bottom, 5)
            .overlay(alignment: .bottom) {
                if rootVM.timeFilter.id == type.id {
                    RoundedRectangle(cornerRadius: 2)
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "DATE_TAB", in: animation)
                }
            }
            .padding(.vertical, 5)
    }
}
