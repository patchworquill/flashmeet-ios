//
//  Utilities.swift
//  nwHacks
//
//  Created by Andrew Richardson on 3/14/15.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import Foundation
import CoreLocation

func async(block: () -> ()) {
    async(dispatch_get_main_queue(), block)
}
func async(queue: dispatch_queue_t, block: () -> ()) {
    dispatch_async(queue, block)
}

func after(delay: Double, block: () -> ()) {
    let dispDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(dispDelay, dispatch_get_main_queue(), block)
}

extension CLLocationCoordinate2D {
    func shiftBy(dlat: CLLocationDegrees, _ dlon: CLLocationDegrees) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude + dlat, longitude: longitude + dlon)
    }
}

class Box<T> {
    var value: T

    init(_ value: T) {
        self.value = value
    }
}
