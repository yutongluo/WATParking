//
//  ParkingLot.swift
//  WATParking
//
//  Created by Yutong Luo on 12/25/15.
//  Copyright © 2015 YTL. All rights reserved.
//

import Foundation
import MapKit

class ParkingLot : NSObject, MKAnnotation {
    let lot_name : String
    let capacity : Int
    var current_count : Int
    var last_updated : NSObject?
    var percent_filled : Int?
    var spots_left : Int
    let coordinate: CLLocationCoordinate2D
    
    init(lot_name : String, capacity : Int, current_count : Int, percent_filled : Int?, coordinate: CLLocationCoordinate2D, last_updated : NSObject?) {
        self.lot_name = lot_name
        self.capacity = capacity
        self.current_count = current_count
        self.percent_filled = percent_filled
        self.coordinate = coordinate
        self.last_updated = last_updated
        
        self.spots_left = self.capacity - self.current_count
        
        super.init()
    }
    
    func update(current_count : Int, percent_filled : Int, last_updated : NSObject) {
        self.current_count = current_count
        self.percent_filled = percent_filled
        self.last_updated = last_updated
    }
    
    var title : String? {
        if let percent = percent_filled {
            return "Lot " + lot_name + ": " + String(percent) + "% Filled with " + String(self.spots_left) + " Spots Left."
        } else {
            return "Lot " + lot_name + ": " + String(self.spots_left) + " Spots Left."
        }
    }
    
    var subtitle : String? {
        return String(current_count) + "/" + String(capacity) + " Last updated:" + String(self.last_updated!)
    }
}