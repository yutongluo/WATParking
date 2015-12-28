//
//  VCTableView.swift
//  WATParking
//
//  Created by Yutong Luo on 12/28/15.
//  Copyright © 2015 YTL. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingLotDict.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let parkingLot = parkingLotArr[indexPath.row]
        let cell : ParkingLotTableViewCell = tableView.dequeueReusableCellWithIdentifier("parkingLotCell", forIndexPath: indexPath) as! ParkingLotTableViewCell
        
        // Set label texts
        cell.percentLabel.text = String(parkingLot.percent_filled!) + "%"
        cell.lotNameLabel.text = parkingLot.lot_name
        cell.updatedLabel.text = (parkingLot.last_updated?.toRelativeString(fromDate: NSDate(), abbreviated: true, maxUnits: 1))! + " ago"
        cell.spotsLeftLabel.text = String(parkingLot.spots_left!)
        
        // Custom highlight color
        let selectColorView = UIView()
        selectColorView.backgroundColor = UIColor(colorLiteralRed: 193 / 255.0, green: 218 / 255.0, blue: 214 / 255.0, alpha: 1)
        cell.selectedBackgroundView =  selectColorView;
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Select annotation
        let selectedParkingLot = parkingLotArr[indexPath.row]
        map.selectAnnotation(selectedParkingLot, animated: true)
    }
}
