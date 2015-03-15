//
//  LeaderboardViewController.swift
//  nwHacks
//
//  Created by Andrew Richardson on 3/15/15.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import UIKit

func ==(lhs: LeaderboardEntry, rhs: LeaderboardEntry) -> Bool {
    return lhs.userID == rhs.userID
}

let leaderboardDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
    return formatter
}()

class LeaderboardViewController: UITableViewController {
    
    var handle: UInt?
    var entries = NSMutableSet()
    let fakeData = true
    
    struct FakeUser {
        let name: String
        let image: UIImage? = nil
        
        init(_ name: String, _ imageURL: String) {
            self.name = name
        }
    }
    
    let sampleUsers = [
        FakeUser("Kanye West", ""),
        FakeUser("Al Gore", ""),
        FakeUser("Bill Gates", ""),
        FakeUser("Julie Calibre", ""),
        FakeUser("Max Planck", "")
    ]

    var sortedEntries: [LeaderboardEntry] {
        return (entries.allObjects as [LeaderboardEntry]).sorted({ (lhs, rhs) -> Bool in
            return lhs.finishedDate.compare(rhs.finishedDate) == .OrderedAscending
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        observeLeaderboard()
    }

    func observeLeaderboard() {
        if fakeData {
            return
        }

        let raceID = DataController.sharedController.raceID!
        handle = leaderboardEndpoint(raceID).observeEventType(.Value, withBlock: { snapshot in
            let users = snapshot.value as [String: String]
            for (userID, timestamp) in users {
                let date = leaderboardDateFormatter.dateFromString(timestamp)!
                let entry = LeaderboardEntry(userID: userID, finishedDate: date)
                self.entries.addObject(entry)
            }
            self.tableView.reloadData()
        })
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeaderboardCell", forIndexPath: indexPath) as LeaderboardCell

        if fakeData {
            let user = sampleUsers[indexPath.row]
            cell.nameLabel.text = user.name
        } else {
            let entry = sortedEntries[indexPath.row]
            cell.profileView.profileID = entry.userID
        }

        return cell
    }
}
