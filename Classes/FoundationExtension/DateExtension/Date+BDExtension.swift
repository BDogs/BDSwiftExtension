//
//  Date+BDExtension.swift
//  Parkinson
//
//  Created by 诸葛游 on 2017/4/27.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation



public extension Date {
    
    
    static let BD_MINUTE: TimeInterval = 60
    static let BD_HOUR: TimeInterval = 3600
    static let BD_DAY: TimeInterval = 86400
    static let BD_WEEK: TimeInterval = 604800
    static let BD_YEAR: TimeInterval = 31556926

    static let BD_WEEKDAY_MAP = [1: "周日", 2: "周一", 3: "周二", 4: "周三", 5: "周四", 6: "周五", 7: "周六"]
    
    static let chineseMonths = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月",
                              "九月", "十月", "冬月", "腊月"]
    static let chineseDays = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
                            "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "廿十",
                            "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]

    
    ///=============================================================================
    /// @name Date Format
    ///=============================================================================
    
    /**
     Returns a formatted string representing this date.
     see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
     for format description.
     
     @param format   String representing the desired date format.
     e.g. @"yyyy-MM-dd HH:mm:ss"
     
     @return NSString representing the formatted date string.
     */
    public func string(format: String, currentCalender: Calendar = Calendar.current) -> String {
        let formatter = DateFormatter()
        formatter.calendar = currentCalender
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    
    
    public static func dateWithString(string: String?, format: String) -> Date? {
        guard let dateString = string else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: dateString)
    }
    
//    func description() -> String {
//        let now = Date()
//        var result: String?
//        
//        return result
//    }
    
    public func isToday(currentCalendar: Calendar = Calendar.current) -> Bool {
        let today = Date()
        
        if today.day(currentCalendar: currentCalendar) == self.day(currentCalendar: currentCalendar) &&
            today.month(currentCalendar: currentCalendar) == self.month(currentCalendar: currentCalendar) &&
            today.year(currentCalendar: currentCalendar) == self.year(currentCalendar: currentCalendar) {
            return true
        } else {
            return false
        }
    }
    
    public func isTheSameMonth(to date: Date, currentCalendar: Calendar = Calendar.current) -> Bool {
        let str1 = string(format: "yyyy-MM", currentCalender: currentCalendar)
        let str2 = date.string(format: "yyyy-MM", currentCalender: currentCalendar)
        return str1 == str2
    }
    
    public func isTheSameDay(to date: Date, currentCalendar: Calendar = Calendar.current) -> Bool {
        let str1 = string(format: "yyyy-MM-dd", currentCalender: currentCalendar)
        let str2 = date.string(format: "yyyy-MM-dd", currentCalender: currentCalendar)
        return str1 == str2
    }
    
    public func isFuture(currentCalendar: Calendar = Calendar.current) -> Bool {
        let today = Date()
        let targetYear = self.year()
        let theYear = today.year()
        if targetYear > theYear {
            return true
        } else if targetYear == theYear {
            let targetMonth = self.month()
            let theMonth = today.month()
            if targetMonth > theMonth {
                return true
            } else if targetMonth == theMonth {
                let targetDay = self.day()
                let theDay = today.day()
                
                if targetDay > theDay {
                    return true
                }
            }
        }
        return false
    }
    
    public func second(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.second, from: self)
    }
    
    public func minute(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.minute, from: self)
    }
    
    public func hour(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.hour, from: self)
    }
    
    public func day(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.day, from: self)
    }
    
    public func weekday(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.weekday, from: self)
    }
    
    public func month(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.month, from: self)
    }
    
    public func year(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.year, from: self)
    }
    
    public func chineseDay(from: Date) -> String? {
        let chineseCalendar = Calendar(identifier: .chinese)
        let components = chineseCalendar.dateComponents([.year, .month, .day], from: from)
        guard let day = components.day else { return nil }
        let d_str = Date.chineseDays[day - 1]
        return d_str
    }
    
    public func dateInTheMonth(day: Int, currentCalendar: Calendar = Calendar.current) -> Date? {
        var components = currentCalendar.dateComponents([.year, .month, .day], from: self)
        components.day = day
        return currentCalendar.date(from: components)
    }
    
    public func firstDateInTheMonth(currentCalendar: Calendar = Calendar.current) -> Date? {
        var components = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let minimum = currentCalendar.date(from: components)
        return minimum
    }
    
    public func daysInTheMonth(currentCalendar: Calendar = Calendar.current) -> Int {
        guard let range = currentCalendar.range(of: .day, in: .month, for: Date()) else {
            return 0
        }
        return range.upperBound - range.lowerBound
    }
    
    
    public func datesInTheMonth(currentCalendar: Calendar = Calendar.current) -> [Date] {
        var dates: [Date] = []
        
        let daysCount = self.daysInTheMonth(currentCalendar: currentCalendar)
        
        guard let firstDate = self.dateInTheMonth(day: 1, currentCalendar: currentCalendar) else {
            return []
        }
        
        guard let finallyDate = self.dateInTheMonth(day: daysCount, currentCalendar: currentCalendar) else {
            return []
        }
        
        let firstWeekday = currentCalendar.component(.weekday, from: firstDate)
        let finallyWeekday = currentCalendar.component(.weekday, from: finallyDate)
        
        if firstWeekday > 1 {
            for i in 1...firstWeekday-1 {
                
                guard let newDate = firstDate.dateByAddingDays(offset: -(firstWeekday-i), currentCalendar: currentCalendar) else {
                    continue
                }
                dates.append(newDate)
            }
        }
        
        for i in 0..<daysCount {
            
            guard let newDate = firstDate.dateByAddingDays(offset: i, currentCalendar: currentCalendar) else {
                continue
            }
            dates.append(newDate)
        }
        
        if finallyWeekday < 7 {
            
            for i in 1...7-finallyWeekday {
                
                guard let newDate = finallyDate.dateByAddingDays(offset: i, currentCalendar: currentCalendar) else {
                    continue
                }
                dates.append(newDate)
            }
        }
        
        return dates
    }
    
    // MARK: - offset
    public func dateByAddingMonths(offset: Int, currentCalendar: Calendar = Calendar.current) -> Date? {
        var components = DateComponents()
        components.month = offset
        return currentCalendar.date(byAdding: components, to: self)
    }
    
    public func dateByAddingDays(offset: Int, currentCalendar: Calendar = Calendar.current) -> Date? {
        var components = DateComponents()
        components.day = offset
        return currentCalendar.date(byAdding: components, to: self)
    }
    
    public func daysFrom(theOne: Date, currentCalendar: Calendar = Calendar.current) -> Int? {
        let components = currentCalendar.dateComponents([.day], from: theOne, to: self)
        return components.day
    }
    
    public func monthsFrom(theOne: Date, currentCalendar: Calendar = Calendar.current) -> Int? {
        let components = currentCalendar.dateComponents([.month], from: theOne, to: self)
        return components.month
    }
    
    //    
    public func midnight(calendar: Calendar = Calendar.current) -> (Date?, Date?) {
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        guard let midnight0 = calendar.date(from: components) else { return (nil, nil) }
        let midnight24 = calendar.date(byAdding: .day, value: 1, to: midnight0, wrappingComponents: false)
        return (midnight0, midnight24)
    }
}
