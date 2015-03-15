//
//  TimerViewUIHelper.swift
//  nwHacks
//
//  Created by Douglas Bumby on 15/03/2015.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import Foundation

extension TimerViewController {
    func setupProgressView() {
        progressView.centralView = timeLabel
        progressView.tintColor = UIColor(red: 62/255, green: 134/255, blue: 80/255, alpha: 1.0)
        progressView.layer.masksToBounds = true
        progressView.borderWidth = 6
        progressView.lineWidth = 6
        displayLink = CADisplayLink(target: self, selector: "updateTime")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        displayLink?.paused = true
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        transitionController.center = progressView.center
        let destVC = segue.destinationViewController as UIViewController
        destVC.transitioningDelegate = transitionController
        destVC.modalPresentationStyle = .Custom
    }
}