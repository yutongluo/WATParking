//
//  BinarySearch.swift
//  WATParking
//
//  Created by Yutong Luo on 12/27/15.
//  Copyright © 2015 YTL. All rights reserved.
//

import Foundation

extension Array {
    
    // Binary insert
    func insertionIndexOf(elem: Element, isOrderedBefore: (Element, Element) -> Bool) -> Int {
        var lo = 0
        var hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if isOrderedBefore(self[mid], elem) {
                lo = mid + 1
            } else if isOrderedBefore(elem, self[mid]) {
                hi = mid - 1
            } else {
                return mid
            }
        }
        return lo
    }
}
