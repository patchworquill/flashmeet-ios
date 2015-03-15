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
    lazy var transitionController = AKCircleMaskTransitionController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInterface()
        updateLoginState()
    }

    func updateLoginState() {
        let loggedIn = DataController.sharedController.isLoggedIn
        loginButton.hidden = loggedIn
        startButton.hidden = !loggedIn
    }

    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        DataController.sharedController.user = CurrentUser(userID: user.objectID, name: user.name)
        updateLoginState()
    }

    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        println("Error! \(error)")
    }
}
