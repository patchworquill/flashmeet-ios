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

class RacerAnnotation: MKPointAnnotation {
    var racerLocation: RacerLocation {
        didSet {
            locationWillChange?(self)
            coordinate = racerLocation.location
            locationDidChange?(self)
        }
    }

    var locationWillChange: ((RacerAnnotation) -> ())?
    var locationDidChange: ((RacerAnnotation) -> ())?

    init(racerLocation: RacerLocation) {
        self.racerLocation = racerLocation
        super.init()
        coordinate = racerLocation.location
    }
}

class RacerAnnotationView: SVPulsingAnnotationView {
    private var animatePositionChanges = false

    override init!(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        updateAnnotationObserver()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var annotation: MKAnnotation! {
        didSet {
            if let oldAnnotation = oldValue as? RacerAnnotation {
                oldAnnotation.locationWillChange = nil
                oldAnnotation.locationDidChange = nil
            }
            updateAnnotationObserver()
        }
    }

    func updateAnnotationObserver() {
        if let racerAnnotation = annotation as? RacerAnnotation {
            racerAnnotation.locationWillChange = { [unowned self] annotation in
                self.animatePositionChanges = true

                let oldVal = annotation.coordinate
                let newVal = annotation.racerLocation.location

                // TODO: Animte position
                let positionAnimation = CABasicAnimation(keyPath: "position")
//                positionAnimation.fromValue = oldVal
//                positionAnimation.toValue = newVal
            }
            racerAnnotation.locationDidChange = { [unowned self] annotation in
                self.animatePositionChanges = false
            }
        }
    }

//    override var center: CGPoint {
//        get { return super.center }
//        set {
//            if animatePositionChanges {
//                UIView.beginAnimations("frameChange", context: nil)
//                UIView.setAnimationDuration(0.3)
//                super.center = newValue
//                UIView.commitAnimations()
//            } else {
//                super.center = newValue
//            }
//        }
//    }
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var mapView: MKMapView!
    lazy var locationManager = CLLocationManager()

    var updateTimer: NSTimer!
    var racerLocations: [Racer: RacerAnnotation] = [:]
    var currentLocation: MKUserLocation?
    var hasUpdatedMapVisibility = false

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
        mapView.setUserTrackingMode(.None, animated: false)
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
        updateMapVisibility()
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
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            showUserLocation()
        }
    }

    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        currentLocation = userLocation
        DataController.sharedController.raceListener("2")
        DataController.sharedController.pushLocation(userLocation.location.coordinate)
        DataController.sharedController.pullDestination("0")
        
        
        updateMapVisibility()
        
        let camera = MKMapCamera()
        camera.centerCoordinate = userLocation.location.coordinate
        camera.heading = 0
        camera.pitch = 80
        camera.altitude = 100
        
        mapView.setCamera(camera, animated: true)
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is RacerAnnotation) {
            let identifier = "racerLocation"
            var annotationView: RacerAnnotationView
            if let view = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? RacerAnnotationView {
                annotationView = view
            } else {
                annotationView = RacerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView.annotationColor = UIColor(red: 0.7, green: 0, blue: 0, alpha: 1)
            }
            return annotationView
        }
        return nil
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

