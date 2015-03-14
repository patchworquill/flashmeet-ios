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

class RacerAnnotation: MKPointAnnotation {
    var racerLocation: RacerLocation {
        didSet {
            coordinate = racerLocation.location
        }
    }

    init(racerLocation: RacerLocation) {
        self.racerLocation = racerLocation
        super.init()
        coordinate = racerLocation.location
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var mapView: MKMapView!
    lazy var locationManager = CLLocationManager()

    var updateTimer: NSTimer!
    var racerLocations: [Racer: RacerAnnotation] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.pitchEnabled = false
        mapView.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateRacerData()
        if updateTimer == nil {
            updateTimer = NSTimer(timeInterval: 15, target: self, selector: "updateRacerData", userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(updateTimer, forMode: NSDefaultRunLoopMode)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            locationManager.requestAlwaysAuthorization()
        } else {
            showUserLocation()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if updateTimer != nil {
            updateTimer.invalidate()
            updateTimer = nil
        }
    }

    func showUserLocation() {
        mapView.showsUserLocation = true
    }

    dynamic func updateRacerData() {
        DataController.sharedController.fetchRacers { racers in
            self.updateRacerLocations(racers)
        }
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
        }
    }

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            showUserLocation()
        }
    }

    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        mapView.setUserTrackingMode(.Follow, animated: true)

        DataController.sharedController.pushLocation(userLocation.location.coordinate)
        
        let camera = MKMapCamera()
        camera.centerCoordinate = userLocation.location.coordinate
        camera.heading = 0
        camera.pitch = 80
        camera.altitude = 100
        
        mapView.setCamera(camera, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

