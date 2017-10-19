//
//  TableViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 11/08/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

struct GroupInfo {
    static let sectionTitles = ["Light", "Middle", "Heavy"]
    static let sectionContents = [["LoadingViewController", "SeparatorLabel", "RaceLampView(Objective-C)"],
                                  ["DialogViewController", "CircleSlider", "CycleThroughView"],
                                  ["NumbersView(Objective-C)", "CalendarView"]]
}

class TableViewController: UITableViewController, TopBarsAppearanceChangable {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTopBarsAppearanceStyle(.default, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return GroupInfo.sectionContents.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GroupInfo.sectionContents[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.textLabel?.text = GroupInfo.sectionContents[indexPath.section][indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = GroupInfo.sectionContents[indexPath.section][indexPath.row].replacingOccurrences(of: "(Objective-C)", with: "")
        navigationController?.pushViewController(UIStoryboard(name: title, bundle: nil).instantiateInitialViewController()!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return GroupInfo.sectionTitles[section]
    }
}
