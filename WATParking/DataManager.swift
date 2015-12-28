//
//  DataManager.swift
//  WATParking
//
//  Created by Yutong Luo on 12/25/15.
//  Copyright © 2015 YTL. All rights reserved.
//

import Foundation


class DataManager {
    let params : String
    let url = "https://api.uwaterloo.ca/v2/parking/watpark.json"
    
    init() {
        // get API Key for plist
        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("keys", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict {
            let x: AnyObject? = dict["uwaterloo_api_key"]
            
            if let key = x as? String {
                self.params = "?key=" + key
                return
            }
        }
        
        // no API key specified
        self.params = ""
    }
    
    func loadDataFromURL(completion:(data: NSDictionary?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        let url = NSURL(string: self.url + self.params)!
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            do {
                if (data == nil) {
                    throw NSError(domain: "Network Failure", code: 1, userInfo: nil)
                }
                // Parse and return deserialized JSON
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data!,options: .MutableContainers) as! NSDictionary
                completion(data: jsonData, error: nil)
            } catch let err as NSError {
                completion(data: nil, error: err)
            }
        })
        
        loadDataTask.resume()
    }
}