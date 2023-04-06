//
//  RKCalendar.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 06.04.2023.
//

import SwiftUI


struct RKCalendar : View {
    
    @State var startIsPresented = false
    @StateObject var rkManager = RKManager(calendar: Calendar.current, minimumDate: Date().startOfYear!, maximumDate: Date().endOfYear!)
    
    var body: some View {
        VStack(spacing: 0) {
            periodSection
            RKViewController(isPresented: self.$startIsPresented, rkManager: self.rkManager)
        }
        .onAppear(perform: startUp)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Selecting a period")
                    .font(.title3.bold())
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: rkManager.startDate)
        .animation(.default, value: rkManager.endDate)
    }
    
    func startUp() {
        // example of some foreground colors
        rkManager.colors.weekdayHeaderColor = Color.blue
        rkManager.colors.monthHeaderColor = Color.secondary
        rkManager.colors.textColor = Color.black
        rkManager.colors.disabledColor = Color.secondary

    }

}


struct RKCalendar_Previews : PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RKCalendar()
        }
    }
}


extension RKCalendar{
    private var periodSection: some View{
        HStack{
            if let start = rkManager.startDate{
                Text(start.formatted(date: .abbreviated, time: .omitted))
            }
            if let end = rkManager.endDate{
                Text(end.formatted(date: .abbreviated, time: .omitted))
            }
        }
    }
}
