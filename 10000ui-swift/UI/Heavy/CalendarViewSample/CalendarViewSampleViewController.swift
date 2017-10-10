//
//  CalendarViewSampleViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 18/09/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

class CalendarViewSampleViewController: UIViewController, TopBarsAppearanceChangable {
    
    @IBOutlet weak var calendarView: CalendarView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTopBarsAppearanceStyle(.custom(color: view.backgroundColor!), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        var preference = CalendarPreference()
//        preference.tintColor = UIColor.green
//        
//        preference.isMonthSelectHidden = true
//        preference.monthSelectRowHeight = 100
//        preference.monthSelectRange = 2...3
        preference.weekTitles = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
//        preference.weekTitlesTextColor = UIColor.blue
//        preference.weekTitlesFont = UIFont.systemFont(ofSize: 11)
//        preference.weekRowHeight = 100
//        
//        preference.isMarkToday = false
//        
//        preference.isPreviousMonthDaySelectable = true
//        preference.isCurrentMonthDaySelectable = true
//        preference.isNextMonthDaySelectable = true
//        preference.isWeekendDaySelectable = true
//        
//        preference.previousMonthDayTextColor = UIColor.purple
//        preference.currentMonthDayTextColor = UIColor.orange
//        preference.nextMonthDayTextColor = UIColor.brown
//        preference.weekendDayTextColor = UIColor.green
//        preference.selectedDayTextColor = UIColor.black
//        
//        preference.dayFont = UIFont.systemFont(ofSize: 20)
//        preference.dayRowHeight = 100
//        
//        preference.separatorStyle = .relativeMargin(margin: 20)
//        preference.separatorColor = UIColor.green.withAlphaComponent(0.5)
        
        calendarView.setCalendarPreference(preference)
        
        calendarView.heightDidChangeClosure = { height in
            
        }
        
    }

}
