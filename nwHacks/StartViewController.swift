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

        startButton.addTarget(self, action: "startButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.readPermissions = ["public_profile", "user_friends"]
        loginButton.delegate = self
        updateLoginState()
    }

    func updateLoginState() {
        let loggedIn = DataController.sharedController.isLoggedIn
        loginButton.hidden = loggedIn
        startButton.hidden = !loggedIn
    }

    dynamic func startButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showTimer", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)

        transitionController.center = startButton.center
        let destVC = segue.destinationViewController as UIViewController
        destVC.transitioningDelegate = transitionController
        destVC.modalPresentationStyle = .Custom
    }

    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        DataController.sharedController.user = CurrentUser(userID: user.objectID, name: user.name)
        updateLoginState()
    }

    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        println("Error! \(error)")
    }
}
