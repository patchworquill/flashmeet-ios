//
//  MapViewController.swift
//  nwHacks
//
//  Created by Andrew Richardson on 3/14/15.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import QuartzCore

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    lazy var locationManager = CLLocationManager()

    var updateTimer: NSTimer!
    var racerLocations: [Racer: RacerAnnotation] = [:]
    var destLocation: DestinationLocation?
    
    var currentLocation: CLLocationCoordinate2D? {
        didSet {
            handleLocationUpdate()
        }
    }

    var hasUpdatedMapVisibility = false
    var arrivedAtDestination = false
    let fakeUserLocation = true

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.pitchEnabled = false
        mapView.delegate = self
    }

    func isLocationAtDestination(loc: CLLocationCoordinate2D) -> Bool {
        if let dest = destLocation?.location {
            let distanceThreshold = 100.0 // meters
            
            return loc.distanceFromCoordinate(dest) < distanceThreshold
        } else {
            
            return false
        }
    }

    func currentUserArrivedAtDestination() {
        if arrivedAtDestination { return }
        arrivedAtDestination = true

        let raceID = DataController.sharedController.raceID!
        let userID = DataController.sharedController.user!.userID

        let timestamp = leaderboardDateFormatter.stringFromDate(NSDate())
        leaderboardEndpoint(raceID).childByAppendingPath(userID).setValue(timestamp, withCompletionBlock: { eror, endpoint in
            self.performSegueWithIdentifier("showLeaderboard", sender: self)
        })
    }

    func updateRacerLocations(newLocations: [RacerLocation]) {
        for loc in newLocations {
            if let annotation = racerLocations[loc.racer] {
                annotation.racerLocation = loc
            } else {
                let annotation = RacerAnnotation(racerLocation: loc)
                racerLocations[loc.racer] = annotation
                mapView.addAnnotation(annotation)
            }

            if isLocationAtDestination(loc.location) {
                // TODO: Handle other user arriving at destination
            }

            if loc.racer.userID == "currentUser" {
                currentLocation = loc.location
            }
        }
        
        updateMapVisibility()
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is RacerAnnotation) {
            let identifier = "racerLocation"
            var annotationView: RacerAnnotationView
            
            if let view = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? RacerAnnotationView {
                annotationView = view
            } else {
                func rcc() -> CGFloat {
                    
                    return CGFloat(arc4random_uniform(255)) / 255
                }

                annotationView = RacerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView.annotationColor = UIColor(red: rcc(), green: rcc(), blue: rcc(), alpha: 1)
                if (annotation as RacerAnnotation).racerLocation.racer.userID == "currentUser" {
                    annotationView.annotationColor = UIColor.blueColor()
                }
            }
            
            return annotationView
        }
        
        return nil
    }
}

