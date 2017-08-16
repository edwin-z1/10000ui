//
//  TopBarsAppearanceChangable.swift
//  blurryssky
//
//  Created by 张亚东 on 01/06/2017.
//  Copyright © 2017 Jumei. All rights reserved.
//

import UIKit

enum TopBarsAppearanceStyle {
    case `default`
    case clearBackground
    case hidden
}

protocol TopBarsAppearanceChangable {
    
    func setTopBarsAppearanceStyle(_ style: TopBarsAppearanceStyle, animated: Bool)
}

extension TopBarsAppearanceChangable where Self: UIViewController {
    
    func setTopBarsAppearanceStyle(_ style: TopBarsAppearanceStyle, animated: Bool) {
        navigationController?.navigationBar.isTranslucent = true
        switch style {
        case .default:
            navigationController?.setNavigationBarHidden(false, animated: animated)
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont.systemFont(ofSize: 16)]
            navigationController?.navigationBar.tintColor = UIColor.white
            
            UIApplication.shared.setStatusBarStyle(.default, animated: animated)
        case .hidden:
            
            navigationController?.setNavigationBarHidden(true, animated: animated)
            UIApplication.shared.setStatusBarStyle(.default, animated: animated)
            
        case .clearBackground:
            navigationController?.setNavigationBarHidden(false, animated: animated)
            
            navigationController?.navigationBar.setBackgroundImage(UIImage.bs.image(withColor: .clear), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage.bs.image(withColor: .clear)
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:UIFont.systemFont(ofSize: 16)]
            navigationController?.navigationBar.tintColor = UIColor.white
            
            UIApplication.shared.setStatusBarStyle(.lightContent, animated: animated)
        }
    }
}
