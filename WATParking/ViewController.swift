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
                
        self.map.delegate = self
        self.parkingLotTableView.delegate = self
        
        dispatch_async(dispatch_get_main_queue(),{
            for key in self.parkingLotDict {
                self.map.addAnnotation(key.1)
            }
        })
        
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
        self.refreshControl.endRefreshing()
    }


}

