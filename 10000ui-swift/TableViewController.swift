//
//  TableViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 11/08/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, TopBarsAppearanceChangable {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTopBarsAppearanceStyle(.default, animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var vc: UIViewController?
        switch indexPath.row {
        case 0:
            vc = UIStoryboard(name: "CircleSlider", bundle: nil).instantiateInitialViewController()!
        default:
            break
        }
        if let vc = vc {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
