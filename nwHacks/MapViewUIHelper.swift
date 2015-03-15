//
//  MapViewUIHelper.swift
//  nwHacks
//
//  Created by Douglas Bumby on 15/03/2015.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import Foundation

extension MapViewController {
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        DataController.sharedController.fetchRaceInfo { destLocation in
            self.updateDestination(destLocation)
        }
        
        updateRacerData()
        
        if updateTimer == nil {
            updateTimer = NSTimer(timeInterval: 3, target: self, selector: "updateRacerData", userInfo: nil, repeats: true)
            NSRunLoop.mainRunLoop().addTimer(updateTimer, forMode: NSDefaultRunLoopMode)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            showUserLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        currentLocation = (locations as? [CLLocation])?.first?.coordinate
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}