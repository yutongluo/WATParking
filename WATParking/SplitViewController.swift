//
//  SplitViewController.swift
//  WATParking
//
//  Created by Yutong Luo on 12/27/15.
//  Copyright © 2015 YTL. All rights reserved.
//

import Foundation
import UIKit

class SplitViewController : UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dataManager : DataManager = DataManager()
        print(dataManager)
    }
}