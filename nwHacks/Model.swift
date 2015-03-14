//
//  Model.swift
//  nwHacks
//
//  Created by Andrew Richardson on 3/14/15.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import Foundation
import CoreLocation

struct Racer {
    var location: CLLocationCoordinate2D
    var name: String
    var profilePhoto: UIImage?
}

private let sharedInstance = DataController()
class DataController {
    class var sharedController: DataController {
        return sharedInstance
    }

    func pushLocation(location: CLLocationCoordinate2D) {
        // TODO
    }

    func fetchRacers(completion: ([Racer]) -> ()) {
        // TODO
        async {
            completion(self.sampleRacerData)
        }
    }

    private let startDate = NSDate()
    private var sampleRacerData: [Racer] {
        let vancouver = CLLocationCoordinate2D(latitude: 49.2827, longitude: 123.1207)
        let offset = -startDate.timeIntervalSinceNow / 1000
        return [
            Racer(location: vancouver.shiftBy(offset, offset),
                    name: "John Smith",
                    profilePhoto: nil)
        ]
    }
}

