//
//  BSCalendarPreference.swift
//  blurryssky
//
//  Created by 张亚东 on 20/07/2017.
//  Copyright © 2017 张亚东. All rights reserved.
//

import UIKit

public struct BSCalendarPreference {
    
    public var tintColor = UIColor.red
    
    public var isMonthSelectHidden = false 
    public var monthSelectRowHeight: CGFloat = 40
    public var monthSelectRange = 1...12 {
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
    public var weekTitles = ["日", "一", "二", "三", "四", "五", "六"]
    public var weekTitlesTextColor = UIColor.lightGray
    public var weekTitlesFont = UIFont.systemFont(ofSize: 14)
    public var weekRowHeight: CGFloat = 40
    
    public var isMarkToday = true
    
    public var isPreviousMonthDaySelectable = false
    public var isCurrentMonthDaySelectable = true
    public var isNextMonthDaySelectable = false
    public var isWeekendDaySelectable = false
    
    public var previousMonthDayTextColor = UIColor.lightGray
    public var currentMonthDayTextColor = UIColor.black
    public var nextMonthDayTextColor = UIColor.lightGray
    public var weekendDayTextColor = UIColor.darkGray
    public var selectedDayTextColor = UIColor.white
    
    public var dayFont = UIFont.systemFont(ofSize: 14)
    public var dayRowHeight: CGFloat = 40
    
    public var separatorStyle: BSCalendarViewSeparatorStyle = .relativeMargin(margin: 5)
    public var separatorColor = UIColor.lightGray.withAlphaComponent(0.5)
}
