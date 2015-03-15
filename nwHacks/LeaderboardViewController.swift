//
//  LeaderboardViewController.swift
//  nwHacks
//
//  Created by Andrew Richardson on 3/15/15.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import UIKit

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

func ==(lhs: LeaderboardEntry, rhs: LeaderboardEntry) -> Bool {
    return lhs.userID == rhs.userID
}

let leaderboardDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
    return formatter
}()

class LeaderboardViewController: UIViewController {
    var handle: UInt?
    var entries = NSMutableSet()

    override func viewDidLoad() {
        super.viewDidLoad()
        observeLeaderboard()
    }

    func observeLeaderboard() {
        let raceID = DataController.sharedController.raceID!
        handle = leaderboardEndpoint(raceID).observeEventType(.Value, withBlock: { snapshot in
            let users = snapshot.value as [String: String]
            for (userID, timestamp) in users {
                let date = leaderboardDateFormatter.dateFromString(timestamp)!
                let entry = LeaderboardEntry(userID: userID, finishedDate: date)
                self.entries.addObject(entry)
            }
        })
    }
}
