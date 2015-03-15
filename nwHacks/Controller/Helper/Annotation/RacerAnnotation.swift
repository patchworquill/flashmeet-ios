//
//  RacerAnnotation.swift
//  nwHacks
//
//  Created by Douglas Bumby on 15/03/2015.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import Foundation

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