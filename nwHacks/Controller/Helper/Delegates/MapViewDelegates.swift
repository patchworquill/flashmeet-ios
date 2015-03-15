//
//  MapViewDelegates.swift
//  nwHacks
//
//  Created by Douglas Bumby on 15/03/2015.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import Foundation

extension MapViewController {
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            showUserLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        currentLocation = (locations as? [CLLocation])?.first?.coordinate
    }
    
    func showUserLocation() {
        if !fakeUserLocation {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    dynamic func updateRacerData() {
        DataController.sharedController.fetchRacers { racers in
            self.updateRacerLocations(racers)
        }
    }
    
    func updateMapVisibility() {
        let animated = hasUpdatedMapVisibility
        mapView.showAnnotations(mapView.annotations, animated: animated)
        hasUpdatedMapVisibility = true
    }
    
    func updateDestination(dest: DestinationLocation) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = dest.location
        mapView.addAnnotation(annotation)
        destLocation = dest
    }
    
    func handleLocationUpdate() {
        updateMapVisibility()
        DataController.sharedController.pushLocation(currentLocation!)
        if isLocationAtDestination(currentLocation!) {
            currentUserArrivedAtDestination()
        }
    }
}