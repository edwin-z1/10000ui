//
//  TimeInterval+bs.swift
//  10000ui-swift
//
//  Created by blurryssky on 2019/3/14.
//  Copyright © 2019 blurryssky. All rights reserved.
//

import Foundation

extension TimeInterval: Namespace {}

extension NamespaceBox where T == TimeInterval {
    
    var formattedColonString: String {
        
        let seconds = Int(floor(base).truncatingRemainder(dividingBy: 60))
        let minutes = Int(floor(base)/60)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "00"
        let secondsString = numberFormatter.string(from: NSNumber(value: seconds)) ?? "00"
        let minutesString = numberFormatter.string(from: NSNumber(value: minutes)) ?? "00"
        
        return "\(minutesString):\(secondsString)"
    }

}

