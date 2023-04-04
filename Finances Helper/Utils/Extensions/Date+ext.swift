//
//  Date+ext.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 31.03.2023.
//


import Foundation

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 00, minute: 0, second: 0, of: self)!
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    func startOfMonth() -> Date{
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date{
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    
    var dayDifferenceStr: String
    {
        let calendar = Calendar.current
        let startOfNow = calendar.startOfDay(for: Date())
        let startOfTimeStamp = calendar.startOfDay(for: self)
        let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
        let day = components.day!
        if abs(day) < 2 {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            formatter.doesRelativeDateFormatting = true
            return formatter.string(from: self)
        } else {
            return onlyDayStr
        }
    }
    
    var onlyDayStr: String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
    
    func getLast6Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -6, to: self)
    }
    
    func getLast3Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -3, to: self)
    }
    
    func getYesterday() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    
    func getLast7Day() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)
    }
    
    func getLast30Day() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -30, to: self)
    }
    
    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    // This Month Start
    func getThisMonthStart() -> Date? {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func getThisMonthEnd() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    // Last Month Start
    func getLastMonthStart() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    // Last Month End
    func getLastMonthEnd() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    var startOfYear: Date? {
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year], from: self)
        return calendar.date(from: component)
    }
    
    var endOfYear: Date? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = calendar.component(.year, from: self)
        components.month = 12
        components.day = 31
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components)
    }

}


