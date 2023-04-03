//
//  StatsView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var rootVM: RootViewModel
    var body: some View {
        DonutChart(chartData: $rootVM.chartData)
            .frame(width: 200, height: 200)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(rootVM: RootViewModel(context: dev.viewContext))
    }
}
