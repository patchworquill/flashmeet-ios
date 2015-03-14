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

    var fireDate = NSDate(timeIntervalSinceNow: 90)
    let startDate = NSDate()

    var displayLink: CADisplayLink!

    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.centralView = timeLabel
        progressView.tintColor = UIColor.redColor()
        progressView.borderWidth = 2
        progressView.lineWidth = 10

        displayLink = CADisplayLink(target: self, selector: "updateTime")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    dynamic func updateTime() {
        let timeRemaining = max(fireDate.timeIntervalSinceNow, 0)
        let mins = Int(timeRemaining / 60) % 60
        let secs = Int(timeRemaining) % 60
        let msecs = Int(timeRemaining * 100) % 100
        timeLabel.text = NSString(format: "%02d:%02d.%02d", mins, secs, msecs) as String

        let progress = -startDate.timeIntervalSinceNow / fireDate.timeIntervalSinceDate(startDate)
        progressView.progress = Float(progress)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
