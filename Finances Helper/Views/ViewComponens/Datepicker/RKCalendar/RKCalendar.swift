//
//  RKCalendar.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 06.04.2023.
//

import SwiftUI


struct RKCalendar : View {
    var dates: (start: Date?, end: Date?)
    @Environment(\.dismiss) private var dismiss
    @StateObject var rkManager = RKManager(calendar: Calendar.current, minimumDate: Date().startOfYear!, maximumDate: Date().endOfYear!)    
    let onTapDone: (Date, Date) -> Void
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerSection
                RKViewController( rkManager: self.rkManager)
            }
            .onAppear(perform: startUp)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Selecting a period")
                        .font(.title3.bold())
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        onTapDone(rkManager.startDate, rkManager.endDate)
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func startUp() {
        
        rkManager.endDate = dates.end ?? Date().startOfWeek
        rkManager.startDate = dates.start ?? Date.now
        
        rkManager.colors.weekdayHeaderColor = Color(.systemGray4)
        rkManager.colors.monthHeaderColor = Color.secondary
        rkManager.colors.textColor = Color.black
        rkManager.colors.todayColor = .red
        rkManager.colors.selectedBackColor = .blue
        rkManager.colors.betweenStartAndEndBackColor = Color(.systemGray2)
    }

}


struct RKCalendar_Previews : PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RKCalendar(dates: (start: Date().startOfWeek, end: Date.tomorrow), onTapDone: {_, _ in})
        }
    }
}


extension RKCalendar{
    private var headerSection: some View{
        VStack(spacing: 10) {
            HStack(spacing: 40){
                dateLabel(title: "Start date", date: rkManager.startDate)
                dateLabel(title: "End date", date: rkManager.endDate)
            }
            .padding(.vertical, 5)
            
            RKWeekdayHeader(rkManager: self.rkManager)
                .padding(.horizontal)
            Divider()
        }
    }
    
    
    private func dateLabel(title: String, date: Date?) -> some View{
        VStack(alignment: .leading){
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(date?.formatted(date: .abbreviated, time: .omitted) ?? "Select")
                .font(.headline)
        }
    }
}
