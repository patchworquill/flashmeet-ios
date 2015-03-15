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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startButton.addTarget(self, action: "startButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let loginView = FBLoginView()
        loginView.delegate = self
    }

    dynamic func startButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showTimer", sender: self)
    }

    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        DataController.sharedController.user = CurrentUser(userID: user.objectID, name: user.name)
    }
}
