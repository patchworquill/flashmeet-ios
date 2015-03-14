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
    var mapView: MKMapView!
    lazy var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        mapView = MKMapView(frame: view.frame)
        mapView.rotateEnabled = true
        mapView.pitchEnabled = false
        mapView.showsPointsOfInterest = false
        mapView.delegate = self
        view.addSubview(mapView)
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
}

