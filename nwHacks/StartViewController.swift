//
//  StartViewController.swift
//  nwHacks
//
//  Created by Andrew Richardson on 3/14/15.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startButton.addTarget(self, action: "startButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    }

    dynamic func startButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showTimer", sender: self)
    }
}
