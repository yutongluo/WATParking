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
    @IBOutlet weak var parkingLotTableView: UITableView!
    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let initialLocation = CLLocation(latitude: 43.471460, longitude: -80.544901)
        centerMapOnLocation(initialLocation)
                
        self.map.delegate = self
        
        dispatch_async(dispatch_get_main_queue(),{
            for key in self.parkingLotDict {
                self.map.addAnnotation(key.1)
            }
        })
        
        self.parkingLotTableView.dataSource = self
        self.parkingLotTableView.beginUpdates()
        let parkingLotArr = Array(parkingLotDict.values)
        print(parkingLotArr)
        self.parkingLotTableView.insertRowsAtIndexPaths([
            NSIndexPath(forRow: parkingLotArr.count-1, inSection: 0)
            ], withRowAnimation: .Automatic)
        self.parkingLotTableView.endUpdates()
        self.parkingLotTableView.reloadData()
        
       
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return parkingLotDict.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let parkingLotArr = Array(parkingLotDict.values)
        let parkingLot = parkingLotArr[indexPath.row]
        let cell : ParkingLotTableViewCell = tableView.dequeueReusableCellWithIdentifier("parkingLotCell", forIndexPath: indexPath) as! ParkingLotTableViewCell
        cell.percentLabel.text = String(parkingLot.percent_filled!) + "%"
        cell.lotNameLabel.text = parkingLot.lot_name
        cell.updatedLabel.text = parkingLot.last_updated?.relativeTime
        cell.spotsLeftLabel.text = String(parkingLot.spots_left!)

        return cell
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2, regionRadius * 2)
        map.setRegion(coordinateRegion, animated: true)
    }


}

