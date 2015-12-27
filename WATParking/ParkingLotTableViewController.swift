//
//  ParkingLotTableViewController.swift
//  WATParking
//
//  Created by Yutong Luo on 12/27/15.
//  Copyright © 2015 YTL. All rights reserved.
//

import Foundation
import UIKit

class ParkingLotTableViewController : UITableViewController {
    
    var parkingLotDict = [String : ParkingLot]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(parkingLotDict)
    }
}