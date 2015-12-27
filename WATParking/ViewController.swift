//
//  ViewController.swift
//  WATParking
//
//  Created by Yutong Luo on 12/25/15.
//  Copyright © 2015 YTL. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    // MARK variables
    
    @IBOutlet weak var map: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    var parkingLotDict = [String : ParkingLot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let initialLocation = CLLocation(latitude: 43.471460, longitude: -80.544901)
        centerMapOnLocation(initialLocation)
        
        let dataManager : DataManager = DataManager()
        
        self.map.delegate = self
        
        dataManager.loadDataFromURL { (data, err) -> Void in
            if let parkingData = data {
                if let parkingLots = parkingData.valueForKey("data") as? NSArray {
                    for lot in parkingLots {
                        if let lot_name = lot.valueForKey("lot_name") as? String {
                            let capacity = lot.valueForKey("capacity") as? Int
                            let current_count = lot.valueForKey("current_count") as? Int
                            let percent_filled = lot.valueForKey("percent_filled") as? Int
                            let latitude = lot.valueForKey("latitude") as? CLLocationDegrees
                            let longitude = lot.valueForKey("longitude") as? CLLocationDegrees
                            let last_updated_string = lot.valueForKey("last_updated") as? String
                            
                            // format date
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                            let last_updated = dateFormatter.dateFromString(last_updated_string!)
                            
                            // construct coordinate
                            let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                            
                            self.parkingLotDict[lot_name] = ParkingLot(lot_name: lot_name, capacity: capacity!, current_count: current_count!, percent_filled: percent_filled, coordinate: coordinate, last_updated: last_updated)
                            
                            dispatch_async(dispatch_get_main_queue(),{
                                for key in self.parkingLotDict {
                                    self.map.addAnnotation(key.1)
                                }
                            })
                            
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2, regionRadius * 2)
        map.setRegion(coordinateRegion, animated: true)
    }


}

