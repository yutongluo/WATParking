//
//  ParkingLot.swift
//  WATParking
//
//  Created by Yutong Luo on 12/25/15.
//  Copyright © 2015 YTL. All rights reserved.
//

import Foundation
import MapKit
import Contacts
import SwiftDate

class ParkingLot : NSObject, MKAnnotation {
    let lot_name : String
    var capacity : Int?
    var current_count : Int?
    var last_updated : NSDate?
    var percent_filled : Int?
    let coordinate: CLLocationCoordinate2D
    
    var spots_left : Int? {
        if (self.capacity != nil && self.current_count != nil) {
            return self.capacity! - self.current_count!
        } else {
            return nil
        }
    }
    
    init(lot_name : String, capacity : Int?, current_count : Int?, percent_filled : Int?, coordinate: CLLocationCoordinate2D, last_updated : NSDate?) {
        self.lot_name = lot_name
        self.capacity = capacity
        self.current_count = current_count
        self.percent_filled = percent_filled
        self.coordinate = coordinate
        self.last_updated = last_updated
        
        super.init()
        
    }
    
    func update(current_count : Int?, percent_filled : Int?, last_updated : NSDate?) {
        self.current_count = current_count ?? self.current_count
        self.percent_filled = percent_filled ?? self.percent_filled
        self.last_updated = last_updated ?? self.last_updated
        
        
    }
    
    // annotation callout info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(CNPostalAddressStreetKey): ""]
        let placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
    var title : String? {
        return "Lot " + lot_name
    }
    
    var subtitle : String? {
        var sub : String = ""
        if let percent = percent_filled {
            sub += String(percent) + "% Filled. "
        }
        if let spots_left = self.spots_left{
            sub += String(spots_left) + " Spots Left."
        }
        if let last_updated = self.last_updated {
            sub += " (Updated " + last_updated.toRelativeString(fromDate: NSDate(), abbreviated: true, maxUnits: 1)! + " ago)"
        }
        return sub
    }
}