//
//  BSCalendarDayCollectionItem.swift
//  blurryssky
//
//  Created by 张亚东 on 16/4/26.
//  Copyright © 2016年 doyen. All rights reserved.
//

import UIKit

public struct BSCalendarDay {

    public var date: Date
    public var currentMonth: Int
    public var isSelected = false
    public var isNextMonthDate = false
    public var isPreviousMonthDate = false
    public var isCurrentMonthDate = false

    init(date: Date, currentMonth: Int) {
        self.date = date
        self.currentMonth = currentMonth
    }
}
