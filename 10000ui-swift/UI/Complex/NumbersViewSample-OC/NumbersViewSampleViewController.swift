//
//  NumbersViewSampleViewController.swift
//  10000ui-swift
//
//  Created by 张亚东 on 09/10/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

import UIKit

fileprivate let cellName = "NumbersViewSampleCollectionCell"

class NumbersViewSampleViewController: UIViewController {

    @IBOutlet weak var numbersView: BSNumbersView!
    fileprivate var headerTexts = ["Flight Company", "Flight Number", "Type Of Aircraft", "Date", "Place Of Departure", "Place Of Destination", "Departure Time", "Arrive Time", "Price"]
    fileprivate var flights: [Flight] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let flightsInfo = NSArray.init(contentsOfFile: Bundle.main.path(forResource: "flights_info", ofType: "plist")!) as! [[String:String]]
        flights = flightsInfo.map { Flight(dictionary: $0) }
        
        
        
//        numbersView.columnsToFreeze = 3
        numbersView.itemMaxWidth = 300
        numbersView.itemMinWidth = 100
        numbersView.rowHeight = 50
        
        numbersView.isFreezeFirstRow = true
        numbersView.delegate = self
        numbersView.dataSource = self
        
        numbersView.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
        //  添加边界线
//    numbersView.layer.borderWidth = 0.5
        
        numbersView.reloadData()
    }
}

extension NumbersViewSampleViewController: BSNumbersViewDataSource {
    
    func numberOfColumns(in numbersView: BSNumbersView) -> Int {
        return flights.first!.bs.propertyStringValues.count
    }
    
    func numberOfRows(in numbersView: BSNumbersView) -> Int {
        // +1是headerData
        return flights.count + 1
    }
    
    func numbersView(_ numbersView: BSNumbersView, attributedStringForItemAt indexPath: BSIndexPath) -> NSAttributedString? {
        
        var string: String!
        if (indexPath.row == 0) {
            string = headerTexts[indexPath.column]
        } else {
            string = flights[indexPath.row - 1].bs.propertyStringValues[indexPath.column]
        }
        
        return NSAttributedString(string: string, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
    }
    
    func numbersView(_ numbersView: BSNumbersView, cellForItemAt indexPath: BSIndexPath) -> UICollectionViewCell? {

        if (indexPath.row != 0) {
            if (indexPath.column == 1) {
                
                let cell = numbersView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! NumbersViewSampleCollectionCell
                cell.label.text = flights[indexPath.row - 1].bs.propertyStringValues[indexPath.column]
                return cell
            }
        }
        return nil
    }
}

extension NumbersViewSampleViewController: BSNumbersViewDelegate {
    
    func numbersView(_ numbersView: BSNumbersView, heightForRow row: Int) -> CGFloat {
        if row%2 == 1 {
            return 50
        } else {
            return 100
        }
    }
    
    func numbersView(_ numbersView: BSNumbersView, widthForColumn column: Int) -> CGFloat {
        if column == 1 {
            return 150
        } else {
            return BSNumbersViewAutomaticDimension
        }
    }
    
    func numbersView(_ numbersView: BSNumbersView, didSelectItemAt indexPath: BSIndexPath) {
        print(indexPath)
        //  if someone need to modify the text, you can use UIAlertController to alert modify text,
        //  then use - (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
        
        if indexPath.row == 0 {
            headerTexts[indexPath.column] = "selected"
            
        } else {
            let flight = flights[indexPath.row - 1]
            let propertyKey = flight.bs.propertyKeys[indexPath.column]
            flight.setValue("selected", forKey: propertyKey)
        }
        numbersView.reloadItems(at: [indexPath])
    }
}

