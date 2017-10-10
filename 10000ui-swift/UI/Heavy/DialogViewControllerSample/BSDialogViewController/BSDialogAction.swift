//
//  BSDialogAction.swift
//  10000ui-swift
//
//  Created by 张亚东 on 19/05/2017.
//  Copyright © 2017 Jumei. All rights reserved.
//

import UIKit

enum BSDialogActionStyle {
    case `default`
    case destructive
    case customFontColor(hexString: String)
}

class BSDialogAction: NSObject {
    
    convenience init(title: String?, style: DialogActionStyle? = .default, handler: ((BSDialogAction) -> Void)? = nil) {
        self.init()
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    fileprivate(set) var title: String?
    fileprivate(set) var style: DialogActionStyle!
    fileprivate(set) var handler: ((BSDialogAction) -> Void)?
    
}
