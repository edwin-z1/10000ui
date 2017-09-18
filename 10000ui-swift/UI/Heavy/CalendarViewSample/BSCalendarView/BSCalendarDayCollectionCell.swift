//
//  BSCalendarDayCollectionCell.swift
//  blurryssky
//
//  Created by 张亚东 on 16/4/26.
//  Copyright © 2016年 doyen. All rights reserved.
//

import UIKit

class BSCalendarDayCollectionCell: UICollectionViewCell {
    
    var preference: BSCalendarPreference! {
        didSet {
            
            dayLabel.font = preference.dayFont
            
            selectedDayView.bs.size = CGSize(width: preference.dayRowHeight * 0.6, height: preference.dayRowHeight * 0.6)
            selectedDayView.center = CGPoint(x: bs.width/2, y: bs.height/2)
            selectedDayView.layer.cornerRadius = preference.dayRowHeight * 0.1
            selectedDayView.backgroundColor = preference.tintColor
            
            let path: UIBezierPath = UIBezierPath()
            path.move(to: .init(x: bs.width * 0.3, y: preference.dayRowHeight * 0.75))
            path.addLine(to: .init(x: bs.width * 0.7, y: preference.dayRowHeight * 0.75))
            path.lineCapStyle = .butt
            todayLineLayer.path = path.cgPath
            todayLineLayer.strokeColor = preference.tintColor.cgColor
        }
    }
    
    var calendarDay: BSCalendarDay! {
        didSet {
            
            dayLabel.text = "\(calendarDay.date.day)"
            dayLabel.textColor = preference.currentMonthDayTextColor
            
            if calendarDay.isSelected == true {
                
                dayLabel.textColor = preference.selectedDayTextColor
                selectedDayView.isHidden = false
                todayLineLayer.isHidden = true

            } else {
                selectedDayView.isHidden = true
                
                if calendarDay.date.isToday {
                    if preference.isMarkToday {
                        CATransaction.begin()
                        CATransaction.setDisableActions(true)
                        todayLineLayer.isHidden = false
                        CATransaction.commit()
                    }
                } else {
                    todayLineLayer.isHidden = true
                }
                
                if calendarDay.date.isWeekend {
                    dayLabel.textColor = preference.weekendDayTextColor
                }
                
                if calendarDay.isPreviousMonthDate {
                    dayLabel.textColor = preference.previousMonthDayTextColor
                } else if calendarDay.isNextMonthDate {
                    dayLabel.textColor = preference.nextMonthDayTextColor
                } else if calendarDay.isCurrentMonthDate {
                    dayLabel.textColor = preference.currentMonthDayTextColor
                }
            }
        }
    }
    
    fileprivate lazy var dayLabel: UILabel = {
        let day: UILabel = UILabel(frame: self.bounds)
        day.textAlignment = .center
        return day
    }()
    
    fileprivate lazy var todayLineLayer: CAShapeLayer = {
        
        let line: CAShapeLayer = CAShapeLayer()
        line.isHidden = true
        line.lineWidth = 2
        return line
    }()
    
    fileprivate lazy var selectedDayView: UIView = {
        let se: UIView = UIView()
        se.isHidden = true
        return se
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(selectedDayView)
        addSubview(dayLabel)
        layer.addSublayer(todayLineLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
