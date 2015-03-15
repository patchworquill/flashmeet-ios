//
//  StartViewUIHelper.swift
//  nwHacks
//
//  Created by Douglas Bumby on 15/03/2015.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import Foundation

extension StartViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        transitionController.center = startButton.center
        
        let destVC = segue.destinationViewController as UIViewController
        destVC.transitioningDelegate = transitionController
        destVC.modalPresentationStyle = .Custom
    }
    
    func setupUserInterface() {
        startButton.addTarget(self, action: "startButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.readPermissions = ["public_profile", "user_friends"]
        loginButton.delegate = self
    }
    
    dynamic func startButtonPressed(sender: UIButton) {
        //        let userID = DataController.sharedController.user!.userID
        //        request(.POST, "http://nwhacks.deltchev.me/api/start-race", parameters: ["userId": userID]).responseString
        //        { (_, _, str, err) in
        self.performSegueWithIdentifier("showTimer", sender: self)
        //        }
    }
}