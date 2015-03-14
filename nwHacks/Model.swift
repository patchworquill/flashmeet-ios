//
//  Model.swift
//  nwHacks
//
//  Created by Andrew Richardson on 3/14/15.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import Foundation
import CoreLocation

struct Racer: Equatable, Hashable {
    var userID: String
    var name: String
    var profilePhoto: UIImage?

    var hashValue: Int {
        return userID.hashValue
    }
}

struct UserLocation {
    var userID: String
    var location: CLLocationCoordinate2D
}

struct RacerLocation {
    var racer: Racer
    var location: CLLocationCoordinate2D
}

struct RacerPath {
    var currentLocation: RacerLocation
    var locationHistory: [CLLocationCoordinate2D]

    init(currentLocation: RacerLocation, locationHistory: [CLLocationCoordinate2D]) {
        self.currentLocation = currentLocation
        self.locationHistory = locationHistory
    }
    init(path: RacerPath, newLocation: RacerLocation) {
        self.currentLocation = newLocation
        self.locationHistory = path.locationHistory + [newLocation.location]
    }
}

func ==(lhs: Racer, rhs: Racer) -> Bool {
    return (lhs.userID == rhs.userID)
}

private let sharedInstance = DataController()
class DataController {
    class var sharedController: DataController {
        return sharedInstance
    }
    
    var userID = "abcd"

    func pushLocation(location: CLLocationCoordinate2D) {
        let locationDict = [
            "userID": userID,
            "lat": location.latitude,
            "long": location.longitude
        ]
        
        usersRef.childByAppendingPath("alanisawesome").setValue(locationDict)
        
    }

    func fetchRacers(completion: ([RacerLocation]) -> ()) {
        // TODO
        async {
            completion(self.sampleRacerData)
        }
    }

    private let startDate = NSDate()
    private var sampleRacerData: [RacerLocation] {
        let ubc = CLLocationCoordinate2D(latitude: 49.266432, longitude: -123.245487)
        let offset = -startDate.timeIntervalSinceNow / 10000
        return [
            RacerLocation(
                racer: Racer(userID: "abcd",
                                name: "John Smith",
                        profilePhoto: nil),
                location: ubc.shiftBy(offset, offset)
            )
        ]
    }
}

