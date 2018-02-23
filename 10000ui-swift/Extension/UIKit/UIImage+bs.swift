//
//  UIImage+bs.swift
//  10000ui-swift
//
//  Created by 张亚东 on 11/08/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

extension NamespaceBox where T: UIImage {
    
    static func image(withColor color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        if size.width <= 0 || size.height <= 0 {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
