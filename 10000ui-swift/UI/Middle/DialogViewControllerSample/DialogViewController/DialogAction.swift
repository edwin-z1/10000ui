//
//  DialogAction.swift
//  10000ui-swift
//
//  Created by 张亚东 on 19/05/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

enum DialogActionStyle {
    case `default`
    case customColor(hexString: String)
}

struct DialogAction {
    
    var title: String?
    var style: DialogActionStyle = .default
    var handler: ((DialogAction) -> Void)?
    
    init(title: String?, style: DialogActionStyle? = .default, handler: ((DialogAction) -> Void)? = nil) {
        self.title = title
        self.style = style!
        self.handler = handler
    }
}
