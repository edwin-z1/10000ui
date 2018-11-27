//
//  TableViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 11/08/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, TopBarsAppearanceChangable {
    
    var groupInfo: [String:[String]]!
    var keys: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let plistPath = Bundle.main.path(forAuxiliaryExecutable: "group_info.plist")!
        let dict = NSDictionary(contentsOfFile: plistPath) as! [String:[String]]
        groupInfo = dict
        keys = dict.keys.map{ $0 }.sorted()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTopBarsAppearanceStyle(.default, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = keys[section]
        return groupInfo[key]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        let key = keys[indexPath.section]
        let value = groupInfo[key]![indexPath.row]
        cell.textLabel?.text = value
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let key = keys[indexPath.section]
        let value = groupInfo[key]![indexPath.row]
        let title = value.replacingOccurrences(of: "(Objective-C)", with: "")
        navigationController?.pushViewController(UIStoryboard(name: title, bundle: nil).instantiateInitialViewController()!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section]
    }
}
