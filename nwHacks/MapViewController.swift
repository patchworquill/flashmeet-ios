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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var mapView: MKMapView!
    lazy var locationManager = CLLocationManager()

    var updateTimer: NSTimer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.pitchEnabled = false
        mapView.delegate = self

        updateTimer = NSTimer(timeInterval: 15, target: self, selector: "updateRacerData", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(updateTimer, forMode: NSDefaultRunLoopMode)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            locationManager.requestAlwaysAuthorization()
        } else {
            showUserLocation()
        }
    }

    func showUserLocation() {
        mapView.showsUserLocation = true
    }

    dynamic func updateRacerData() {
        DataController.sharedController.fetchRacers { racers in
            // TODO: Display racers on the map
        }
    }

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            showUserLocation()
        }
    }

    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        mapView.setUserTrackingMode(.Follow, animated: true)

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

