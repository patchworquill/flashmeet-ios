//
//  LeaderboardEntry.swift
//  nwHacks
//
//  Created by Douglas Bumby on 15/03/2015.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import Foundation

class LeaderboardEntry: Equatable, Hashable {
    let userID: String
    let finishedDate: NSDate
    
    init(userID: String, finishedDate: NSDate) {
        self.userID = userID
        self.finishedDate = finishedDate
    }
    
    var hashValue: Int {
        return userID.hashValue
    }
}