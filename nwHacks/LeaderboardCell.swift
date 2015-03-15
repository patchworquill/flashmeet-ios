//
//  LeaderboardCell.swift
//  nwHacks
//
//  Created by Andrew Richardson on 3/15/15.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import UIKit

class LeaderboardCell: UITableViewCell {
    @IBOutlet var profileView: FBProfilePictureView!
    @IBOutlet var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
