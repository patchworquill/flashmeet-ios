//
//  TimerViewController.swift
//  nwHacks
//
//  Created by Andrew Richardson on 3/14/15.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import UIKit
import QuartzCore

class TimerViewController: UIViewController {
    
    @IBOutlet var progressView: UAProgressView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var doneLabel: UILabel!

    lazy var transitionController = AKCircleMaskTransitionController()
    let fireDate = NSDate(timeIntervalSinceNow: 5)
    let startDate = NSDate()
    var displayLink: CADisplayLink!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressView()
    }
    
    func timerExpired() {
        displayLink.paused = true
        doneLabel.hidden = false
        doneLabel.alpha = 0
        
        UIView.animateWithDuration(0.6) {
            self.timeLabel.alpha = 0
        }
        
        after(0.25) {
            self.progressView.tintColor = UIColor.purpleColor()//(red: 80/255, green:200/255, blue:50/255, alpha: 1)
            UIView.animateWithDuration(0.75, animations: {
                self.doneLabel.alpha = 1
                }, completion: { finished in
                    self.timeLabel.hidden = true
                    after(0.5) {
                        self.performSegueWithIdentifier("showMapView", sender: self)
                    }
            })
        }
    }

    dynamic func updateTime() {
        let timeRemaining = max(fireDate.timeIntervalSinceNow, 0)
        let mins = Int(timeRemaining / 60) % 60
        let secs = Int(timeRemaining) % 60
        let msecs = Int(timeRemaining * 100) % 100
        timeLabel.text = NSString(format: "%02d:%02d.%02d", mins, secs, msecs) as String

        let progress = -startDate.timeIntervalSinceNow / fireDate.timeIntervalSinceDate(startDate)
        progressView.progress = Float(progress)

        let timePastExpired = fireDate.timeIntervalSinceNow <= 0
        
        if timePastExpired {
            timerExpired()
        }
    }
}
