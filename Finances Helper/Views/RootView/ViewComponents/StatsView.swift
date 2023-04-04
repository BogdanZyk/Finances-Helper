//
//  StatsView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct StatsView: View {
    @Namespace var animation
    @ObservedObject var rootVM: RootViewModel
    @Binding var chartData: [ChartData]
    var body: some View {
        VStack(spacing: 10){
            datePickerButtons
            dateTitle
            DonutChart(chartData: $chartData)
                .frame(height: 200)
                .padding(.vertical, 26)
        }
        .padding()
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
            .padding()
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color(.systemGray6)
            StatsView(rootVM: RootViewModel(context: dev.viewContext), chartData: .constant(ChartData.sample))
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
                Text(type.title)
                    .font(.headline)
                    .foregroundColor(rootVM.timeFilter == type ? Color.black : .secondary)
                    .padding(.bottom, 5)
                    .overlay(alignment: .bottom) {
                        if rootVM.timeFilter == type {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "DATE_TAB", in: animation)
                        }
                    }
                    .padding(.vertical, 5)
                    .onTapGesture {
                        rootVM.timeFilter = type
                    }
            }
            Text("Period")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom, 5)
                .padding(.vertical, 5)
        }
        .animation(.spring(), value: rootVM.timeFilter)
    }
}
