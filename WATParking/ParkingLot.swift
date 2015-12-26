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
        if let percent = percent_filled {
            return String(percent) + "% Filled; " + String(self.spots_left) + " Spots Left."
        } else {
            return String(self.spots_left) + " Spots Left."
        }
    }
}