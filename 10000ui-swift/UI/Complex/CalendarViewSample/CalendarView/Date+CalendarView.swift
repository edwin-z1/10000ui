//
//  Date+BS.swift
//  10000ui-swift
//
//  Created by 张亚东 on 20/07/2017.
//  Copyright © 2017 张亚东. All rights reserved.
//

import Foundation

extension Date {
    
    var isFuture: Bool {
        return compare(Date()) == .orderedDescending
    }
    
    var isPast: Bool {
        return compare(Date()) == .orderedAscending
    }
    
    func componentFor(_ component: Calendar.Component) -> Int {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.component(component, from: self)
    }
    
    init(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        
        guard let date = Calendar.autoupdatingCurrent.date(from: dateComponents) else {
            self = Date()
            return
        }
        self = date
    }
}
