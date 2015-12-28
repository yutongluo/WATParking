//
//  ViewController.swift
//  WATParking
//
//  Created by Yutong Luo on 12/25/15.
//  Copyright © 2015 YTL. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // MARK variables
    let regionRadius: CLLocationDistance = 1000
    var parkingLotDict = [String : ParkingLot]()
    var parkingLotArr = [ParkingLot]()
    @IBOutlet weak var parkingLotTableView: UITableView!
    @IBOutlet var map: MKMapView!
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let initialLocation = CLLocationCoordinate2D(latitude: 43.471460, longitude: -80.544901)
        centerMapOnLocation(initialLocation)
        
        // Set delegates
        self.map.delegate = self
        self.parkingLotTableView.delegate = self
        
        // Add annotations to map in main queue
        dispatch_async(dispatch_get_main_queue(),{
            self.map.addAnnotations(self.parkingLotArr)
        })
        
        // Add rows to tableview
        self.parkingLotTableView.dataSource = self
        self.parkingLotTableView.beginUpdates()
        self.parkingLotTableView.insertRowsAtIndexPaths([
            NSIndexPath(forRow: parkingLotArr.count-1, inSection: 0)
            ], withRowAnimation: .Automatic)
        self.parkingLotTableView.endUpdates()
        self.parkingLotTableView.reloadData()
        
        // refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.parkingLotTableView.addSubview(refreshControl)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingLotDict.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let parkingLot = parkingLotArr[indexPath.row]
        let cell : ParkingLotTableViewCell = tableView.dequeueReusableCellWithIdentifier("parkingLotCell", forIndexPath: indexPath) as! ParkingLotTableViewCell
        cell.percentLabel.text = String(parkingLot.percent_filled!) + "%"
        cell.lotNameLabel.text = parkingLot.lot_name
        cell.updatedLabel.text = parkingLot.last_updated?.relativeTime
        cell.spotsLeftLabel.text = String(parkingLot.spots_left!)

        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedParkingLot = parkingLotArr[indexPath.row]
        map.selectAnnotation(selectedParkingLot, animated: true)
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
            regionRadius * 2, regionRadius * 2)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func refresh(sender: AnyObject) {
        print("Refreshing")
        let dataManager : DataManager = DataManager()
        
        // date formatter
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        dataManager.loadDataFromURL { (data, err) -> Void in
            if let parkingData = data {
                if let parkingLots = parkingData.valueForKey("data") as? NSArray {
                    for lot in parkingLots {
                        if let lot_name = lot.valueForKey("lot_name") as? String {
                            let capacity = lot.valueForKey("capacity") as? Int
                            let current_count = lot.valueForKey("current_count") as? Int
                            let percent_filled = lot.valueForKey("percent_filled") as? Int
                            let last_updated_string = lot.valueForKey("last_updated") as? String
                            let last_updated = dateFormatter.dateFromString(last_updated_string!)
                            
                            if let existingParkingLot = self.parkingLotDict[lot_name] {
                                // Update existing parking lot
                                if let last_updated_existing = existingParkingLot.last_updated {
                                    if last_updated_existing != last_updated {
                                        // Only update if time stamp is different
                                        print("Updating lot " + lot_name)
                                        existingParkingLot.update(current_count, percent_filled: percent_filled, last_updated: last_updated)
                                    }
                                }
                            } else {
                                // New parking Lot
                                let latitude = lot.valueForKey("latitude") as? CLLocationDegrees
                                let longitude = lot.valueForKey("longitude") as? CLLocationDegrees
                                
                                // Only add if coordinates are known
                                if let lat = latitude {
                                    if let long = longitude {
                                        // construct coordinate
                                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                        
                                        // add lot to dictionary
                                        self.parkingLotDict[lot_name] = ParkingLot(lot_name: lot_name, capacity: capacity, current_count: current_count, percent_filled: percent_filled, coordinate: coordinate, last_updated: last_updated)
                                        // add lot to array
                                        self.parkingLotArr.insertionIndexOf(self.parkingLotDict[lot_name]!, isOrderedBefore: {$0.last_updated!.compare($1.last_updated!) == .OrderedDescending})
                                        
                                        // add lot to map
                                        dispatch_async(dispatch_get_main_queue(),{
                                            self.map.addAnnotation(self.parkingLotDict[lot_name]!)
                                        })
                                        
                                        // Add rows to tableview
                                        self.parkingLotTableView.beginUpdates()
                                        self.parkingLotTableView.insertRowsAtIndexPaths([
                                            NSIndexPath(forRow: self.parkingLotArr.count-1, inSection: 0)
                                            ], withRowAnimation: .Automatic)
                                        self.parkingLotTableView.endUpdates()
                                    }
                                }
                            }
                        }
                    }
                    self.parkingLotTableView.reloadData()
                    self.refreshControl.endRefreshing()
                    
                }
            } else {
                // No parking data
                self.refreshControl.endRefreshing()

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
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

}

