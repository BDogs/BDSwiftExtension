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
    func string(format: String = "dd/MM/yyyy HH:mm", currentCalender: Calendar = Calendar.current) -> String {
        let formatter = DateFormatter()
        formatter.calendar = currentCalender
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    
    
    static func dateWithString(string: String?, format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
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
    
    func isToday(currentCalendar: Calendar = Calendar.current) -> Bool {
        let today = Date()
        
        if today.day(currentCalendar: currentCalendar) == self.day(currentCalendar: currentCalendar) &&
            today.month(currentCalendar: currentCalendar) == self.month(currentCalendar: currentCalendar) &&
            today.year(currentCalendar: currentCalendar) == self.year(currentCalendar: currentCalendar) {
            return true
        } else {
            return false
        }
    }
    
    func isTheSameMonth(to date: Date, currentCalendar: Calendar = Calendar.current) -> Bool {
        let str1 = string(format: "yyyy-MM", currentCalender: currentCalendar)
        let str2 = date.string(format: "yyyy-MM", currentCalender: currentCalendar)
        return str1 == str2
    }
    
    func isTheSameDay(to date: Date, currentCalendar: Calendar = Calendar.current) -> Bool {
        let str1 = string(format: "yyyy-MM-dd", currentCalender: currentCalendar)
        let str2 = date.string(format: "yyyy-MM-dd", currentCalender: currentCalendar)
        return str1 == str2
    }
    
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Check if date is within yesterday.
    ///
    ///     Date().isInYesterday -> false
    ///
    var isInYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// Check if date is within tomorrow.
    ///
    ///     Date().isInTomorrow -> false
    ///
    var isInTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    /// Check if date is within a weekend period.
    var isInWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    
    /// Check if date is within a weekday period.
    var isWorkday: Bool {
        return !Calendar.current.isDateInWeekend(self)
    }
    
    /// Check if date is within the current week.
    var isInCurrentWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    /// Check if date is within the current month.
    var isInCurrentMonth: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    /// Check if date is within the current year.
    var isInCurrentYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }

    
    var isInPast: Bool {
        return self < Date()
    }
    
    /// check if a date is between two other dates
    ///
    /// - Parameters:
    ///   - startDate: start date to compare self to.
    ///   - endDate: endDate date to compare self to.
    ///   - includeBounds: true if the start and end date should be included (default is false)
    /// - Returns: true if the date is between the two given dates.
    func isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return startDate.compare(self).rawValue * compare(endDate).rawValue >= 0
        }
        return startDate.compare(self).rawValue * compare(endDate).rawValue > 0
    }
    
    /// check if a date is a number of date components of another date
    ///
    /// - Parameters:
    ///   - value: number of times component is used in creating range
    ///   - component: Calendar.Component to use.
    ///   - date: Date to compare self to.
    /// - Returns: true if the date is within a number of components of another date
    func isWithin(_ value: UInt, _ component: Calendar.Component, of date: Date) -> Bool {
        let components = Calendar.current.dateComponents([component], from: self, to: date)
        let componentValue = components.value(for: component)!
        return abs(componentValue) <= value
    }
    
    /// Random date between two dates.
    ///
    ///     Date.random()
    ///     Date.random(from: Date())
    ///     Date.random(upTo: Date())
    ///     Date.random(from: Date(), upTo: Date())
    ///
    /// - Parameters:
    ///   - fromDate: minimum date (default is Date.distantPast)
    ///   - toDate: maximum date (default is Date.distantFuture)
    /// - Returns: random date between two dates.
    static func random(from fromDate: Date = Date.distantPast, upTo toDate: Date = Date.distantFuture) -> Date {
        guard fromDate != toDate else {
            return fromDate
        }
        
        let diff = llabs(Int64(toDate.timeIntervalSinceReferenceDate - fromDate.timeIntervalSinceReferenceDate))
        var randomValue: Int64 = 0
        arc4random_buf(&randomValue, MemoryLayout<Int64>.size)
        randomValue = llabs(randomValue%diff)
        
        let startReferenceDate = toDate > fromDate ? fromDate : toDate
        return startReferenceDate.addingTimeInterval(TimeInterval(randomValue))
    }

    
    func isFuture(currentCalendar: Calendar = Calendar.current) -> Bool {
        let today = Date()
        
        return self > today
//        let targetYear = self.year()
//        let theYear = today.year()
//        if targetYear > theYear {
//            return true
//        } else if targetYear == theYear {
//            let targetMonth = self.month()
//            let theMonth = today.month()
//            if targetMonth > theMonth {
//                return true
//            } else if targetMonth == theMonth {
//                let targetDay = self.day()
//                let theDay = today.day()
//
//                if targetDay > theDay {
//                    return true
//                }
//            }
//        }
//        return false
    }
    
    func second(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.second, from: self)
    }
    
    func minute(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.minute, from: self)
    }
    
    func hour(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.hour, from: self)
    }
    
    /// Hour.
    ///
    ///     Date().hour -> 17 // 5 pm
    ///
    ///     var someDate = Date()
    ///     someDate.hour = 13 // sets someDate's hour to 1 pm.
    ///
    var hour: Int {
        get {
            return Calendar.current.component(.hour, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentHour = Calendar.current.component(.hour, from: self)
            let hoursToAdd = newValue - currentHour
            if let date = Calendar.current.date(byAdding: .hour, value: hoursToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Minutes.
    ///
    ///     Date().minute -> 39
    ///
    ///     var someDate = Date()
    ///     someDate.minute = 10 // sets someDate's minutes to 10.
    ///
    var minute: Int {
        get {
            return Calendar.current.component(.minute, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMinutes = Calendar.current.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = Calendar.current.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Seconds.
    ///
    ///     Date().second -> 55
    ///
    ///     var someDate = Date()
    ///     someDate.second = 15 // sets someDate's seconds to 15.
    ///
    var second: Int {
        get {
            return Calendar.current.component(.second, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentSeconds = Calendar.current.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            if let date = Calendar.current.date(byAdding: .second, value: secondsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Nanoseconds.
    ///
    ///     Date().nanosecond -> 981379985
    ///
    ///     var someDate = Date()
    ///     someDate.nanosecond = 981379985 // sets someDate's seconds to 981379985.
    ///
    var nanosecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .nanosecond, in: .second, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentNanoseconds = Calendar.current.component(.nanosecond, from: self)
            let nanosecondsToAdd = newValue - currentNanoseconds
            
            if let date = Calendar.current.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// Milliseconds.
    ///
    ///     Date().millisecond -> 68
    ///
    ///     var someDate = Date()
    ///     someDate.millisecond = 68 // sets someDate's nanosecond to 68000000.
    ///
    var millisecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self) / 1000000
        }
        set {
            let nanoSeconds = newValue * 1000000
            let allowedRange = Calendar.current.range(of: .nanosecond, in: .second, for: self)!
            guard allowedRange.contains(nanoSeconds) else { return }
            
            if let date = Calendar.current.date(bySetting: .nanosecond, value: nanoSeconds, of: self) {
                self = date
            }
        }
    }

    
    /// Day.
    ///
    ///     Date().day -> 12
    ///
    ///     var someDate = Date()
    ///     someDate.day = 1 // sets someDate's day of month to 1.
    ///
    var day: Int {
        get {
            return Calendar.current.component(.day, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentDay = Calendar.current.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = Calendar.current.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }
    
    func day(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.day, from: self)
    }
    
    func weekday(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.weekday, from: self)
    }
    
    /// Month.
    ///
    ///     Date().month -> 1
    ///
    ///     var someDate = Date()
    ///     someDate.month = 10 // sets someDate's month to 10.
    ///
    var month: Int {
        get {
            return Calendar.current.component(.month, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMonth = Calendar.current.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            if let date = Calendar.current.date(byAdding: .month, value: monthsToAdd, to: self) {
                self = date
            }
        }
    }
    
    func month(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.month, from: self)
    }
    
    /// Year.
    ///
    ///        Date().year -> 2017
    ///
    ///        var someDate = Date()
    ///        someDate.year = 2000 // sets someDate's year to 2000
    ///
    var year: Int {
        get {
            return Calendar.current.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = Calendar.current.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = Calendar.current.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }
    
    func year(currentCalendar: Calendar = Calendar.current) -> Int {
        return currentCalendar.component(.year, from: self)
    }
    
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }
    
    func chineseDay(from: Date) -> String? {
        let chineseCalendar = Calendar(identifier: .chinese)
        let components = chineseCalendar.dateComponents([.year, .month, .day], from: from)
        guard let day = components.day else { return nil }
        let d_str = Date.chineseDays[day - 1]
        return d_str
    }
    
    func dateInTheMonth(day: Int, currentCalendar: Calendar = Calendar.current) -> Date? {
        var components = currentCalendar.dateComponents([.year, .month, .day], from: self)
        components.day = day
        return currentCalendar.date(from: components)
    }
    
    func firstDateInTheMonth(currentCalendar: Calendar = Calendar.current) -> Date? {
        var components = currentCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let minimum = currentCalendar.date(from: components)
        return minimum
    }
    
    func daysInTheMonth(currentCalendar: Calendar = Calendar.current) -> Int {
        guard let range = currentCalendar.range(of: .day, in: .month, for: Date()) else {
            return 0
        }
        return range.upperBound - range.lowerBound
    }
    
    
    func datesInTheMonth(currentCalendar: Calendar = Calendar.current) -> [Date] {
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
    func dateByAddingMonths(offset: Int, currentCalendar: Calendar = Calendar.current) -> Date? {
        var components = DateComponents()
        components.month = offset
        return currentCalendar.date(byAdding: components, to: self)
    }
    
    func dateByAddingDays(offset: Int, currentCalendar: Calendar = Calendar.current) -> Date? {
        var components = DateComponents()
        components.day = offset
        return currentCalendar.date(byAdding: components, to: self)
    }
    
    func daysFrom(theOne: Date, currentCalendar: Calendar = Calendar.current) -> Int? {
        let components = currentCalendar.dateComponents([.day], from: theOne, to: self)
        return components.day
    }
    
    func monthsFrom(theOne: Date, currentCalendar: Calendar = Calendar.current) -> Int? {
        let components = currentCalendar.dateComponents([.month], from: theOne, to: self)
        return components.month
    }
    
    //    
    func midnight(calendar: Calendar = Calendar.current) -> (Date?, Date?) {
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        guard let midnight0 = calendar.date(from: components) else { return (nil, nil) }
        let midnight24 = calendar.date(byAdding: .day, value: 1, to: midnight0, wrappingComponents: false)
        return (midnight0, midnight24)
    }
}


public extension Date {
    /// Quarter 季度.
    ///
    ///        Date().quarter -> 3 // date in third quarter of the year.
    ///
    var quarter: Int {
        let month = Double(Calendar.current.component(.month, from: self))
        let numberOfMonths = Double(Calendar.current.monthSymbols.count)
        let numberOfMonthsInQuarter = numberOfMonths / 4
        return Int(ceil(month/numberOfMonthsInQuarter))
    }
    
    init(year: Int?=nil, month: Int?=nil, day: Int?=nil, hour: Int?=nil, minute: Int?=nil, second: Int?=nil, nanosecond: Int?=nil) {
        
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: Date())
        if let year = year { components.year = year }
        if let month = month { components.month = month }
        if let day = day { components.day = day }
        if let hour = hour { components.hour = hour }
        if let minute = minute { components.minute = minute }
        if let second = second { components.second = second }
        if let nanosecond = nanosecond { components.nanosecond = nanosecond }


        self = Calendar.current.date(from: components)!
    }
    
    /// 根据“分”取整点
    func nearest(minutes: Int) -> Date? {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        guard let currentMinute = components.minute else { return nil }
        let mid = minutes/2 + 1
        let remainder = currentMinute % minutes
        
        components.minute = remainder < mid ? currentMinute-remainder : currentMinute-remainder+minutes
        components.second = 0
        components.nanosecond = 0
        return Calendar.current.date(from: components)
    }
    
    /// Date at the beginning of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:14 PM"
    ///     let date2 = date.beginning(of: .hour) // "Jan 12, 2017, 7:00 PM"
    ///     let date3 = date.beginning(of: .month) // "Jan 1, 2017, 12:00 AM"
    ///     let date4 = date.beginning(of: .year) // "Jan 1, 2017, 12:00 AM"
    ///
    /// - Parameter component: calendar component to get date at the beginning of.
    /// - Returns: date at the beginning of calendar component (if applicable).
    func beginning(of component: Calendar.Component) -> Date? {
        if component == .day {
            return Calendar.current.startOfDay(for: self)
        }
        
        var components: Set<Calendar.Component> {
            switch component {
            case .second:
                return [.year, .month, .day, .hour, .minute, .second]
                
            case .minute:
                return [.year, .month, .day, .hour, .minute]
                
            case .hour:
                return [.year, .month, .day, .hour]
                
            case .weekOfYear, .weekOfMonth:
                return [.yearForWeekOfYear, .weekOfYear]
                
            case .month:
                return [.year, .month]
                
            case .year:
                return [.year]
                
            default:
                return []
            }
        }
        
        guard !components.isEmpty else { return nil }
        return Calendar.current.date(from: Calendar.current.dateComponents(components, from: self))
    }

    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }
    
    mutating func add(_ component: Calendar.Component, value: Int) {
        if let date = Calendar.current.date(byAdding: component, value: value, to: self) {
            self = date
        }
    }
    
    /// Date at the end of calendar component.
    ///
    ///     let date = Date() // "Jan 12, 2017, 7:27 PM"
    ///     let date2 = date.end(of: .day) // "Jan 12, 2017, 11:59 PM"
    ///     let date3 = date.end(of: .month) // "Jan 31, 2017, 11:59 PM"
    ///     let date4 = date.end(of: .year) // "Dec 31, 2017, 11:59 PM"
    ///
    /// - Parameter component: calendar component to get date at the end of.
    /// - Returns: date at the end of calendar component (if applicable).
    func end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            var date = adding(.second, value: 1)
            date = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date))!
            date.add(.second, value: -1)
            return date
            
        case .minute:
            var date = adding(.minute, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
            date = after.adding(.second, value: -1)
            return date
            
        case .hour:
            var date = adding(.hour, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month, .day, .hour], from: date))!
            date = after.adding(.second, value: -1)
            return date
            
        case .day:
            var date = adding(.day, value: 1)
            date = Calendar.current.startOfDay(for: date)
            date.add(.second, value: -1)
            return date
            
        case .weekOfYear, .weekOfMonth:
            var date = self
            let beginningOfWeek = Calendar.current.date(from:
                Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            date = beginningOfWeek.adding(.day, value: 7).adding(.second, value: -1)
            return date
            
        case .month:
            var date = adding(.month, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year, .month], from: date))!
            date = after.adding(.second, value: -1)
            return date
            
        case .year:
            var date = adding(.year, value: 1)
            let after = Calendar.current.date(from:
                Calendar.current.dateComponents([.year], from: date))!
            date = after.adding(.second, value: -1)
            return date
            
        default:
            return nil
        }
    }
}
