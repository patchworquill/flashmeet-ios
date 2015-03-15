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

struct CurrentUser {
    var userID: String
    var name: String
}

private let sharedInstance = DataController()
class DataController {
    class var sharedController: DataController {
        return sharedInstance
    }

    private var fakeLogin = false
    
    var user: CurrentUser? {
        didSet {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(user?.userID, forKey: "userID")
            defaults.setValue(user?.name, forKey: "userName")
        }
    }

    var isLoggedIn: Bool {
        return user != nil
    }

    init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let userID = defaults.valueForKey("userID") as? String {
            let name = defaults.valueForKey("userName") as String
            user = CurrentUser(userID: userID, name: name)
        }

        if user == nil && fakeLogin {
            user = CurrentUser(userID: "abcd", name: "Joe Schmo")
        }
    }

    func pushLocation(location: CLLocationCoordinate2D) {
        let locationDict = [
            "lat": location.latitude,
            "long": location.longitude
        ]
        
        usersRef.childByAppendingPath(user!.userID).setValue(locationDict)
        
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
                                name: "John Smith"),
                location: ubc.shiftBy(offset, offset)
            )
        ]
    }
}

