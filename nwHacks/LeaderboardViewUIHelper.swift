//
//  LeaderboardViewUIHelper.swift
//  nwHacks
//
//  Created by Douglas Bumby on 15/03/2015.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import Foundation

extension LeaderboardViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeData ? sampleUsers.count : entries.count
    }
}