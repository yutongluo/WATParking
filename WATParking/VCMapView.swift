//
//  VCMapView.swift
//  WATParking
//
//  Created by Yutong Luo on 12/26/15.
//  Copyright © 2015 YTL. All rights reserved.
//
import Foundation
import MapKit

extension ViewController: MKMapViewDelegate {
    
    func mapView(map: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ParkingLot {
            let identifier = "pin"
            var view: MKPinAnnotationView
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: UIButtonType.InfoLight) as UIView
            
            if (annotation.current_count != nil && annotation.capacity != nil) {
                let percent = annotation.percent_filled ?? annotation.current_count! / annotation.capacity!
                switch percent {
                case 0..<50:
                    view.pinTintColor = UIColor.greenColor()
                    break
                case 51..<80:
                    view.pinTintColor = UIColor.yellowColor()
                    break
                case 81..<90:
                    view.pinTintColor = UIColor.orangeColor()
                    break
                default:
                    view.pinTintColor = UIColor.redColor()
                }
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
            let location = view.annotation as! ParkingLot
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
}
