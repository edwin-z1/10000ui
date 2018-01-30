//
//  CalendarDay.swift
//  10000ui-swift
//
//  Created by 张亚东 on 16/4/26.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

import UIKit

class CalendarDay {

    var date: Date
    var isSelected = false
    var isNextMonthDate = false
    var isPreviousMonthDate = false
    var isCurrentMonthDate = false

    init(date: Date) {
        self.date = date
    }
}
