//
//  BSCalendarMonthCollectionItem.swift
//  10000ui-swift
//
//  Created by 张亚东 on 16/4/26.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

import UIKit

class CalendarMonth {

    //  day is not valid
    var date: Date
    var days: [CalendarDay]
    
    init(date: Date, days: [CalendarDay]) {
        self.date = date
        self.days = days
    }
}
