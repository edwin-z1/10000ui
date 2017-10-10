//
//  DialogTextStyleView.swift
//  10000ui-swift
//
//  Created by 张亚东 on 19/05/2017.
//  Copyright © 2017 Jumei. All rights reserved.
//

import UIKit

class DialogTextStyleView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.adjustsFontSizeToFitWidth = true
        messageLabel.adjustsFontSizeToFitWidth = true
    }
}
