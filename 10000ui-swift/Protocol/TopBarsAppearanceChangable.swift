//
//  TopBarsAppearanceChangable.swift
//  10000ui-swift
//
//  Created by 张亚东 on 01/06/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

enum TopBarsAppearanceStyle {
    case `default`
    case clearBackground
    case hidden
    case custom(color: UIColor)
}

protocol TopBarsAppearanceChangable {
    
    func setTopBarsAppearanceStyle(_ style: TopBarsAppearanceStyle, animated: Bool)
}

extension TopBarsAppearanceChangable where Self: UIViewController {
    
    func setTopBarsAppearanceStyle(_ style: TopBarsAppearanceStyle, animated: Bool) {
        
        switch style {
        case .default:
            navigationController?.setNavigationBarHidden(false, animated: animated)
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black, NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)]
            navigationController?.navigationBar.tintColor = UIColor.black
            
            UIApplication.shared.setStatusBarStyle(.default, animated: animated)
        case .hidden:
            
            navigationController?.setNavigationBarHidden(true, animated: animated)
            UIApplication.shared.setStatusBarStyle(.default, animated: animated)
            
        case .clearBackground:
            navigationController?.setNavigationBarHidden(false, animated: animated)
            
            navigationController?.navigationBar.setBackgroundImage(UIImage.bs.image(withColor: .clear), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage.bs.image(withColor: .clear)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)]
            navigationController?.navigationBar.tintColor = UIColor.white
            
            UIApplication.shared.setStatusBarStyle(.lightContent, animated: animated)
        case let .custom(color):
            navigationController?.setNavigationBarHidden(false, animated: animated)
            
            navigationController?.navigationBar.setBackgroundImage(UIImage.bs.image(withColor: color), for: .default)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)]
            navigationController?.navigationBar.tintColor = UIColor.white
            
            UIApplication.shared.setStatusBarStyle(.lightContent, animated: animated)
        }
    }
}
