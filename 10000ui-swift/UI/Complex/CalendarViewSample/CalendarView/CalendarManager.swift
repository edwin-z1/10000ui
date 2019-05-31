//
//  CalendarManager.swift
//  10000ui-swift
//
//  Created by 张亚东 on 16/5/20.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

import UIKit

class CalendarManager: NSObject {
    
    var monthRange = 1...12 {
        didSet {
            setupMonths()
        }
    }
    
    fileprivate(set) var nowCalendarMonth: CalendarMonth?
    fileprivate(set) var calendarMonths: [CalendarMonth]!
    
    private let now = Date()
    private lazy var year = now.componentFor(.year)
    private lazy var month = now.componentFor(.month)
    
    override init() {
        super.init()
        setupMonths()
    }
}

fileprivate extension CalendarManager {
    
    func setupMonths() {
        
        let startMonth = monthRange.lowerBound
        let endMonth = monthRange.upperBound
        
        calendarMonths = (startMonth...endMonth).map {
            CalendarMonth(date: Date(year: year, month: $0, day: 1), days: getDays(withMonth: $0))
        }
        
        if monthRange.contains(month) {
            nowCalendarMonth = calendarMonths[month - startMonth]
        } else {
            nowCalendarMonth = nil
        }
        
    }
    
    func getDays(withMonth month:Int) -> [CalendarDay] {

        var days: [CalendarDay] = []
        
        days.append(contentsOf: getPreviousMonthDays(withMonth: month))
        days.append(contentsOf: getCurrentMonthDays(withMonth: month))
        days.append(contentsOf: getNextMonthDays(withMonth: month))

        return days
    }
    
    func getPreviousMonthDays(withMonth month:Int) -> [CalendarDay] {
        
        let firstDayDate = Date(year: year, month: month, day: 1)
        let firstDayWeekDay = firstDayDate.componentFor(.weekday)
        
        return (1..<firstDayWeekDay).reversed().map {
            let dayDate = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -$0, to: firstDayDate) ?? Date()
            let calendarDay = CalendarDay(date: dayDate)
            calendarDay.isPreviousMonthDate = true
            return calendarDay
        }
    }
    
    func getCurrentMonthDays(withMonth month:Int) -> [CalendarDay] {
        
        let firstDayDate = Date(year: year, month: month, day: 1)
        let calendar = Calendar.autoupdatingCurrent
        let days = calendar.range(of: .day, in: .month, for: firstDayDate)
        let daysInMonth = days?.count ?? 0
        
        return (1...daysInMonth).map({
            let calendarDay = CalendarDay(date: Date(year: year, month: month, day: $0))
            calendarDay.isCurrentMonthDate = true
            return calendarDay
        })
    }
    
    func getNextMonthDays(withMonth month:Int) -> [CalendarDay] {
        
        let firstDayDate = Date(year: year, month: month, day: 1)
        let calendar = Calendar.autoupdatingCurrent
        let days = calendar.range(of: .day, in: .month, for: firstDayDate)
        let daysInMonth = days?.count ?? 0
        let lastDayDate = Date(year: year, month: month, day: daysInMonth)
        let lastDayWeekDay = lastDayDate.componentFor(.weekday)
        
        return (0..<(7 - lastDayWeekDay)).map({
            let dayDate = Calendar.autoupdatingCurrent.date(byAdding: .day, value: $0 + 1, to: lastDayDate) ?? Date()
            let calendarDay = CalendarDay(date: dayDate)
            calendarDay.isNextMonthDate = true
            return calendarDay
        })
    }
}
