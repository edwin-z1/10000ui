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
        return isLater(than: Date())
    }
    
    var isPast: Bool {
        return isEarlier(than: Date())
    }
}
