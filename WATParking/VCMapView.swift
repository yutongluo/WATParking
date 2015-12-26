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
            if let dequeuedView = map.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton() as UIView
            }
            return view
        }
        return nil
    }
}
