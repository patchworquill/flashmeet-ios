//
//  RacerAnnotationView.swift
//  nwHacks
//
//  Created by Douglas Bumby on 15/03/2015.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import Foundation

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