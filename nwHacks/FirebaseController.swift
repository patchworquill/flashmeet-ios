//
//  FirebaseController.swift
//  nwHacks
//
//  Created by Patrick Wilkie on 2015-03-14.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import Foundation

let rootRef = Firebase(url:"https://nwhacks.firebaseio.com/")
let racesRef = Firebase(url:"https://nwhacks.firebaseio.com/races")
let usersRef = Firebase(url:"https://nwhacks.firebaseio.com/users")


func leaderboardEndpoint(raceID: String) -> Firebase {
    return racesRef.childByAppendingPath(raceID).childByAppendingPath("finishes")
}

