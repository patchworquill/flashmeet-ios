//
//  StartViewController.swift
//  nwHacks
//
//  Created by Andrew Richardson on 3/14/15.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, FBLoginViewDelegate {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var loginButton: FBLoginView!

    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.addTarget(self, action: "startButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)

        loginButton.delegate = self

        let loggedIn = DataController.sharedController.isLoggedIn
        loginButton.hidden = loggedIn
        startButton.hidden = !loggedIn
    }

    dynamic func startButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showTimer", sender: self)
    }

    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        DataController.sharedController.user = CurrentUser(userID: user.objectID, name: user.name)
    }
}
