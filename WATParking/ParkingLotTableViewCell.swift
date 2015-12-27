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
    @IBOutlet weak var lotNameLabel: UILabel!
    @IBOutlet weak var percentFilledLabel: UILabel!
    @IBOutlet weak var availableSpotsLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}