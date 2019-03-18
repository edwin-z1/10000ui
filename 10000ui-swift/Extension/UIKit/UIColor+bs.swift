//
//  UIColor+bs.swift
//  10000ui-swift
//
//  Created by 张亚东 on 10/10/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import Foundation

extension NamespaceBox where T: UIColor {
    
    static func color(hexString: String, alpha: CGFloat = 1.0) -> UIColor? {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            return nil
        }
    }
    
    static func random(alpha: CGFloat? = 1) -> UIColor {
        let red = CGFloat(arc4random()%255)/255
        let green = CGFloat(arc4random()%255)/255
        let blue = CGFloat(arc4random()%255)/255
        return UIColor(red: red, green: green, blue: blue, alpha: alpha!)
    }
}

extension NamespaceBox where T: UIColor {
    
    func convert(to color: UIColor, multiplier: CGFloat) -> UIColor? {
        let multiplier = min(max(multiplier, 0), 1)
        
        let components = base.cgColor.components ?? []
        let toComponents = color.cgColor.components ?? []
        
        if components.isEmpty || components.count < 3 || toComponents.isEmpty || toComponents.count < 3 {
            return nil
        }
        
        var results: [CGFloat] = []
        
        for index in 0...3 {
            let result = (toComponents[index] - components[index]) * abs(multiplier) + components[index]
            results.append(result)
        }
        
        return UIColor(red: results[0], green: results[1], blue: results[2], alpha: results[3])
    }
}
