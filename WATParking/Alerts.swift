//
//  Alerts.swift
//  WATParking
//
//  Created by Yutong Luo on 12/28/15.
//  Copyright © 2015 YTL. All rights reserved.
//

import Foundation
import UIKit

class Alerts {
    static func dataErrorAlert(err : NSError?, action: UIAlertAction) -> UIAlertController {
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
        alert.addAction(action)
        return alert
    }
}