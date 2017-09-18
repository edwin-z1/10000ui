//
//  BSCalendarMonthCollectionCell.swift
//  blurryssky
//
//  Created by 张亚东 on 16/4/26.
//  Copyright © 2016年 doyen. All rights reserved.
//

import UIKit

class BSCalendarMonthCollectionCell: UICollectionViewCell {
    
    var dayDidSelectedClosure: ((BSCalendarDay) -> Void)?
    
    var preference: BSCalendarPreference!
    
    var calendarMonth: BSCalendarMonth? {
        didSet {
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    fileprivate var selectedIndexPath: IndexPath?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.estimatedItemSize = CGSize(width: self.bs.width/7,
                                              height: 40)
        flowLayout.headerReferenceSize = CGSize(width: self.bs.width, height: 1/UIScreen.main.scale)
        
        let c : UICollectionView = UICollectionView(frame: self.bounds,
                                                    collectionViewLayout: flowLayout)
        c.register(BSCalendarDayCollectionCell.self,
                        forCellWithReuseIdentifier: "BSCalendarDayCollectionCell")
        c.register(BSCalendarDayCollectionReusableHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BSCalendarDayCollectionReusableHeaderView")
        c.dataSource = self
        c.delegate = self
        c.backgroundColor = UIColor.clear
        c.isScrollEnabled = false
        return c
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BSCalendarMonthCollectionCell: UICollectionViewDataSource {
    
    var daysCount: Int {
        guard let daysCount = calendarMonth?.days.count else {
            return 0
        }
        return daysCount
    }
    
    var sectionsCount: Int {
        return Int(ceil(Double(daysCount)/7))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BSCalendarDayCollectionCell", for: indexPath) as! BSCalendarDayCollectionCell
        
        cell.preference = preference
        cell.calendarDay = calendarMonth!.days[indexPath.section * 7 + indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var view = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader {
            view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BSCalendarDayCollectionReusableHeaderView", for: indexPath)
            let headerView = view as! BSCalendarDayCollectionReusableHeaderView
            headerView.separatorStyle = preference.separatorStyle
            headerView.lineLayer.strokeColor = preference.separatorColor.cgColor
        }
        return view
    }
}

extension BSCalendarMonthCollectionCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bs.width/7, height: preference.dayRowHeight)
    }
}

extension BSCalendarMonthCollectionCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? BSCalendarDayCollectionCell else {
            return
        }

        if cell.calendarDay.isCurrentMonthDate {
            guard preference.isCurrentMonthDaySelectable else {
                return
            }
        } else if cell.calendarDay.isPreviousMonthDate {
            guard preference.isPreviousMonthDaySelectable else {
                return
            }
        } else if cell.calendarDay.isNextMonthDate {
            guard preference.isNextMonthDaySelectable else {
                return
            }
        } else if cell.calendarDay.date.isWeekend {
            guard preference.isWeekendDaySelectable else {
                return
            }
        }
        
        cell.calendarDay.isSelected = true
        dayDidSelectedClosure?(cell.calendarDay)
        
        if let lastIndexPath = selectedIndexPath,
            let lastCell = collectionView.cellForItem(at: lastIndexPath) as? BSCalendarDayCollectionCell {
            guard lastIndexPath != indexPath else {
                return
            }
            lastCell.calendarDay.isSelected = false
        }
        selectedIndexPath = indexPath
    }
}

