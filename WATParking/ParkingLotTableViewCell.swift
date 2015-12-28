//
//  ParkingLotTableViewCell.swift
//  WATParking
//
//  Created by Yutong Luo on 12/26/15.
//  Copyright © 2015 YTL. All rights reserved.
//

import Foundation
import UIKit

class ParkingLotTableViewCell : UITableViewCell{
    
    // MARK: variables
    @IBOutlet weak var lotNameLabel: UILabel!
    @IBOutlet var percentLabel: UILabel!
    @IBOutlet var spotsLeftLabel: UILabel!
    @IBOutlet var updatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Customize border for lotName
        lotNameLabel.layer.borderWidth = 1
        lotNameLabel.layer.borderColor = UIColor.grayColor().CGColor
    }
}