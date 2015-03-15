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

class LeaderboardViewController: UITableViewController {
    var handle: UInt?
    var entries = NSMutableSet()

    struct FakeUser {
        let name: String
        let image: UIImage? = nil

        init(_ name: String, _ imageURL: String) {
            self.name = name
//            let imageData = NSData(contentsOfURL: NSURL(string: imageURL)!)!
//            self.image = UIImage(data: imageData)!
        }
    }

    let sampleUsers = [
        FakeUser("Kanye West", ""),
        FakeUser("Al Gore", ""),
        FakeUser("Bill Gates", ""),
        FakeUser("Julie Calibre", ""),
        FakeUser("Max Planck", "")
    ]

    let fakeData = true

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

    func fetchUserInfo() {
        // TODO: Get usernames
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeData ? sampleUsers.count : entries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeaderboardCell", forIndexPath: indexPath) as LeaderboardCell

        if fakeData {
            let user = sampleUsers[indexPath.row]
//            cell.profileView.hidden = true
//            cell.imageView!.image = user.image
            cell.nameLabel.text = user.name
        } else {
            let entry = sortedEntries[indexPath.row]
            cell.profileView.profileID = entry.userID
        }

        return cell
    }
}
