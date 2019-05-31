//
//  TopBarsAppearanceChangable.swift
//  10000ui-swift
//
//  Created by 张亚东 on 01/06/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

enum NavigationBarStyle {
    case `default`
    case black
    case white
    case hidden
    case clear
    case custom(bgColor: UIColor, tintColor: UIColor, textColor: UIColor)
}

protocol NavigationBarChangable {
    func setNavigationBarStyle(_ style: NavigationBarStyle)
}

extension NavigationBarChangable where Self: UIViewController {
    
    func setNavigationBarStyle(_ style: NavigationBarStyle) {
        
        guard let navigationBar = navigationController?.navigationBar else {
            return
        }
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        switch style {
        case .`default`:
            
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = nil
            navigationBar.barStyle = .default
            navigationBar.tintColor = UIColor.black
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
            
        case .black:

            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = nil
            navigationBar.barStyle = .black
            navigationBar.tintColor = UIColor.white
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            
        case .white:
            
            navigationBar.setBackgroundImage(UIImage.bs.image(withColor: UIColor.white), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.barStyle = .default
            navigationBar.tintColor = UIColor.black
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
            
        case .hidden:
            
            navigationController?.setNavigationBarHidden(true, animated: true)
            
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = nil
            navigationBar.barStyle = .blackTranslucent
            navigationBar.tintColor = UIColor.clear
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
            
        case .clear:
            
            navigationBar.setBackgroundImage(UIImage.bs.image(withColor: UIColor.clear), for: .default)
            navigationBar.shadowImage = UIImage.bs.image(withColor: UIColor.clear)
            navigationBar.barStyle = .blackTranslucent
            navigationBar.tintColor = UIColor.white
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            
        case let .custom(bgColor, tintColor, textColor):
            
            navigationBar.setBackgroundImage(UIImage.bs.image(withColor: bgColor), for: .default)
            navigationBar.shadowImage = UIImage.bs.image(withColor: bgColor)
            navigationBar.barStyle = .default
            navigationBar.tintColor = tintColor
            navigationBar.titleTextAttributes = [.foregroundColor: textColor]

        }
    }
}
