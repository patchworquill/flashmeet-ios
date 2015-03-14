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

extension CLLocationCoordinate2D {
    func shiftBy(dlat: CLLocationDegrees, _ dlon: CLLocationDegrees) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude + dlat, longitude: longitude + dlon)
    }
}
