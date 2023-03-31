//
//  StatsView.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var rootVM: RootViewModel
    
    var slicesValue: [SliceValue]{
        rootVM.transactions.compactMap({$0.sliceValue})
    }
                       
    var categores: [SliceCategory]{
        rootVM.categories.compactMap({$0.slice})
    }
    var body: some View {
        
        PieChartView(values: slicesValue, names: categores, formatter: {$0.treeNumString + " $"})
            .frame(height: 200)
        
        
        //        ProgressCircleView(persentage: 0.7, lineWidth: 30, circleOutline: .blue, circleTrack: Color(.systemGray3)) {
        //            VStack(alignment: .center){
        //                Text(rootVM.transactionsStats.incomeAmontStr)
        //                    .font(.title3.bold())
        //                    .foregroundColor(.green)
        //                Text(rootVM.transactionsStats.expenseAmountStr)
        //                    .font(.title3.bold())
        //                    .foregroundColor(.red)
        //            }
        //        }
        //        .frame(width: 200, height: 200)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(rootVM: RootViewModel(context: dev.viewContext))
    }
}
