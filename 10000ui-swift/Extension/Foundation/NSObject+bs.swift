//
//  NSObject+bs.swift
//  10000ui-swift
//
//  Created by 张亚东 on 09/10/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import Foundation

extension NamespaceBox where T: NSObject {
    
    var propertyKeys: [String] {
        
        var outCount: UInt32 = 0
        let properties = class_copyPropertyList(type(of: base), &outCount)!
        
        return (0...(outCount-1)).compactMap {
            let p = properties[Int($0)]
            let key = String(cString: property_getName(p))
            return key
        }
    }
    
    var propertyStringValues: [String] {
        
        var outCount: UInt32 = 0
        let properties = class_copyPropertyList(type(of: base), &outCount)!
        
        return (0...(outCount-1)).compactMap {
            let p = properties[Int($0)]
            let key = String(cString: property_getName(p))
            let value = base.value(forKey: key) as? String
            return value
        }
    }
    
    static var string: String {
        return String(describing: T.self)
    }
    
}
