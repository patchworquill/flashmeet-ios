//
//  Model.swift
//  nwHacks
//
//  Created by Andrew Richardson on 3/14/15.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import Foundation
import CoreLocation

struct RaceSession {
    var raceID: String
    var initiatorID: String
    var participantIDs: [String]
    var participantStartDates: [String: NSDate]
    var destinationID: Int
}

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

struct DestinationLocation {
    var destID: Int
    var name: String
    var adress: String
    var description: String
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

    private let fakeLogin = true
    private let fakeRace = true
    
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

    var raceSession: RaceSession?

    var raceID: String? {
        return raceSession?.raceID
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

        if fakeRace {
            raceSession = RaceSession(raceID: "-JkRBcXhZggcIwx-Ut_J", initiatorID: "1234", participantIDs: ["1234"], participantStartDates: ["1234": NSDate()], destinationID: 1)
        }
    }

    func pushLocation(location: CLLocationCoordinate2D) {
        let locationDict = [
            "lat": location.latitude,
            "long": location.longitude
        ]
        usersRef.childByAppendingPath(user!.userID).setValue(locationDict)
    }

    func fetchRaceInfo(completion: (DestinationLocation) -> ()) {
        var thisRaceRef = racesRef.childByAppendingPath(raceID!)

        thisRaceRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let dict = snapshot.value as NSDictionary
            // No if-let because Swift bugs :(
            let destID = dict["destination"] as Int
            let initiator = dict["initiator"] as String
            let participantDict = dict["participants"] as [String: String]
            let participantIDs = participantDict.keys.array

            var startDates: [String: NSDate] = [:]
            for (pid, timestamp) in participantDict {
                startDates[pid] = leaderboardDateFormatter.dateFromString(timestamp)
            }

            let session = RaceSession(raceID: self.raceID!, initiatorID: initiator, participantIDs: participantIDs, participantStartDates: startDates, destinationID: destID)
            self.fetchDestinationInfo(destID, completion: completion)

//            if destID != nil {
//                self.fetchDestinationInfo(destID!, completion)
//            } else {
//                // Wait until a change occurs if no value is available
//                thisRaceRef.observeSingleEventOfType(.ChildChanged, withBlock: { snapshot in
//                    let destID = getDestID(snapshot)!
//                    self.fetchDestinationInfo(destID, completion)
//                })
//            }
        })
    }
    
    private func fetchDestinationInfo(destID: Int, completion: (DestinationLocation) -> ()) {
        let endpoint = destRef.childByAppendingPath(String(destID))
        endpoint.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let destDict = snapshot.value as NSDictionary
            let destName = destDict["name"] as String
            let destAddress = destDict["address"] as String
            let destDisc = destDict["description"] as String
            let destLat = destDict["lat"] as Double
            let destLong = destDict["long"] as Double
            let destCoords = CLLocationCoordinate2D(latitude: destLat, longitude: destLong)
            let finalDest = DestinationLocation(destID: destID, name: destName, adress: destAddress, description: destDisc, location: destCoords)
            completion(finalDest)
        })
    }

    func fetchRacers(completion: ([RacerLocation]) -> ()) {
        if fakeRace {
            async {
                completion(self.sampleRacerData)
            }
            return
        }

        usersRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let dict = snapshot.value as NSDictionary
            var locations: [RacerLocation] = []
            for pid in self.raceSession!.participantIDs {
                if let locDict = dict[pid] as? NSDictionary {
                    let racer = Racer(userID: pid, name: "A Name")
                    let lat = locDict["lat"] as Double
                    let lon = locDict["long"] as Double
                    let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    locations.append(RacerLocation(racer: racer, location: coord))
                }
            }
            completion(locations)
        })
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

