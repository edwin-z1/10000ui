//
//  CalendarPreference.swift
//  10000ui-swift
//
//  Created by 张亚东 on 20/07/2017.
//  Copyright © 2017 张亚东. All rights reserved.
//

import UIKit

struct CalendarPreference {
    
    var tintColor = UIColor.red
    
    var isMonthSelectHidden = false
    var monthSelectRowHeight: CGFloat = 40
    var monthSelectRange = 1...12 {
        didSet {
            guard monthSelectRange.lowerBound >= 1,
                monthSelectRange.upperBound <= 12,
                monthSelectRange.lowerBound <= monthSelectRange.upperBound else {
                    monthSelectRange = oldValue
                    return
            }
        }
    }
    
    /// only change the text
    var weekTitles = ["日", "一", "二", "三", "四", "五", "六"]
    var weekTitlesTextColor = UIColor.lightGray
    var weekTitlesFont = UIFont.systemFont(ofSize: 14)
    var weekRowHeight: CGFloat = 40
    
    var isMarkToday = true
    
    var isPreviousMonthDaySelectable = false
    var isCurrentMonthDaySelectable = true
    var isNextMonthDaySelectable = false
    var isWeekendDaySelectable = false
    
    var previousMonthDayTextColor = UIColor.lightGray
    var currentMonthDayTextColor = UIColor.black
    var nextMonthDayTextColor = UIColor.lightGray
    var weekendDayTextColor = UIColor.darkGray
    var selectedDayTextColor = UIColor.white
    
    var dayFont = UIFont.systemFont(ofSize: 14)
    var dayRowHeight: CGFloat = 40
    
    var separatorStyle: CalendarViewSeparatorStyle = .relativeMargin(margin: 5)
    var separatorColor = UIColor.lightGray.withAlphaComponent(0.5)
}
