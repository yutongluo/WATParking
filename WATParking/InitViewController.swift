//
//  InitViewController.swift
//  WATParking
//
//  Created by Yutong Luo on 12/27/15.
//  Copyright © 2015 YTL. All rights reserved.
//

import MapKit
import UIKit


class InitViewController: UIViewController {
    
    var parkingLotDict = [String : ParkingLot]()
    
    // MARK variables
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dataManager : DataManager = DataManager()
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
                            
                            
                            // Only add if coordinates are known
                            if let lat = latitude {
                                if let long = longitude {
                                    // construct coordinate
                                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                    
                                    self.parkingLotDict[lot_name] = ParkingLot(lot_name: lot_name, capacity: capacity, current_count: current_count, percent_filled: percent_filled, coordinate: coordinate, last_updated: last_updated)
                                }
                            }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                        self.performSegueWithIdentifier("doneInit", sender: nil)
                    })
                }
            } else {
                var msg = "Something went wrong :("
                if let errno = err?.code {
                    switch errno {
                    case 1:
                        msg = "Could not get parking data :( Is your device connected to the internet?"
                        break;
                    case 2:
                        msg = "Could not parse parking data :("
                    default:
                        break;
                    }
                }
                let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Quit", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                    exit(0)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "doneInit" {
            if let destination = segue.destinationViewController as? ViewController {
                destination.parkingLotDict = self.parkingLotDict
            }
        }
    }
}