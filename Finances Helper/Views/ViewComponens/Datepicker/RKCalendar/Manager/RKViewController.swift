//
//  RKViewController.swift
//  RKCalendar
//
//  Created by Raffi Kian on 7/14/19.
//  Copyright © 2019 Raffi Kian. All rights reserved.
//

import SwiftUI

struct RKViewController: View {
    
    @ObservedObject var rkManager: RKManager
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 32) {
                    ForEach(0..<numberOfMonths(), id: \.self) { index in
                        RKMonth(rkManager: self.rkManager, monthOffset: index)
                            .id(index)
                    }
                    .padding()
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    if let date = rkManager.startDate{
                        proxy.scrollTo(getMonthFromDate(date: date), anchor: .center)
                    }
                }
            }
        }
    }
    
    func numberOfMonths() -> Int {
        return rkManager.calendar.dateComponents([.month], from: rkManager.minimumDate, to: RKMaximumDateMonthLastDay()).month! + 1
    }
    
    func RKMaximumDateMonthLastDay() -> Date {
        var components = rkManager.calendar.dateComponents([.year, .month, .day], from: rkManager.maximumDate)
        components.month! += 1
        components.day = 0
        
        return rkManager.calendar.date(from: components)!
    }
    
    func getMonthFromDate(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        return components.month! - 1
    }

}

#if DEBUG
struct RKViewController_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            RKViewController( rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365)))
            RKViewController( rkManager: RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*32)))
                .environment(\.colorScheme, .dark)
                .environment(\.layoutDirection, .rightToLeft)
        }
    }
}
#endif

