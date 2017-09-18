//
//  BSCalendarManager.swift
//  blurryssky
//
//  Created by 张亚东 on 16/5/20.
//  Copyright © 2016年 doyen. All rights reserved.
//

import UIKit

class BSCalendarManager: NSObject {
    
    var monthRange = 1...12 {
        didSet {
            setupMonths()
        }
    }
    
    fileprivate(set) var nowCalendarMonth: BSCalendarMonth?
    fileprivate(set) var calendarMonths: [BSCalendarMonth]!
    
    fileprivate let now = Date()
    
    override init() {
        super.init()
        setupMonths()
    }
}

fileprivate extension BSCalendarManager {
    
    func setupMonths() {
        
        let startMonth = monthRange.lowerBound
        let endMonth = monthRange.upperBound
        
        calendarMonths = (startMonth...endMonth).map {
            BSCalendarMonth(date: Date(year: now.year, month: $0, day: 1), month: $0, days: getDays(withMonth: $0))
        }
        
        if monthRange.contains(now.month) {
            nowCalendarMonth = calendarMonths[now.month - startMonth]
        } else {
            nowCalendarMonth = nil
        }
        
    }
    
    func getDays(withMonth month:Int) -> [BSCalendarDay] {

        var days: [BSCalendarDay] = []
        
        days.append(contentsOf: getPreviousMonthDays(withMonth: month))
        days.append(contentsOf: getCurrentMonthDays(withMonth: month))
        days.append(contentsOf: getNextMonthDays(withMonth: month))

        return days
    }
    
    func getPreviousMonthDays(withMonth month:Int) -> [BSCalendarDay] {
        
        let firstDayDate = Date(year: now.year, month: month, day: 1)
        let firstDayWeekDay = firstDayDate.weekday
        
        return (1..<firstDayWeekDay).map {
            var tc = TimeChunk()
            tc.days = firstDayWeekDay - $0
            let dayDate = firstDayDate.subtract(tc)
            var calendarDay = BSCalendarDay(date: dayDate, currentMonth: month - 1)
            calendarDay.isPreviousMonthDate = true
            return calendarDay
        }
    }
    
    func getCurrentMonthDays(withMonth month:Int) -> [BSCalendarDay] {
        
        let firstDayDate = Date(year: now.year, month: month, day: 1)
        let daysInMonth = firstDayDate.daysInMonth
        
        return (1...daysInMonth).map({
            var calendarDay = BSCalendarDay(date: Date(year: now.year, month: month, day: $0), currentMonth: month)
            calendarDay.isCurrentMonthDate = true
            return calendarDay
        })
    }
    
    func getNextMonthDays(withMonth month:Int) -> [BSCalendarDay] {
        
        let nextMonthFirstDayDate = Date(year: now.year, month: month + 1, day: 1)
        var tc = TimeChunk()
        tc.days = 1
        let lastDayDate = nextMonthFirstDayDate.subtract(tc)
        let lastDayWeekDay = lastDayDate.weekday
        
        return (0..<(7 - lastDayWeekDay)).map({
            var calendarDay = BSCalendarDay(date: Date(year: now.year, month: month + 1, day: $0 + 1), currentMonth: month + 1)
            calendarDay.isNextMonthDate = true
            return calendarDay
        })
    }
}
