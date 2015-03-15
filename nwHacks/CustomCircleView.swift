//
//  CustomCircleView.swift
//  nwHacks
//
//  Created by Douglas Bumby on 15/03/2015.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import UIKit

@IBDesignable
class CustomCircleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(UIColor.greenColor(), radius: 6)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(UIColor.greenColor(), radius: 6)
    }
    
    func setup(color: UIColor, radius: CGFloat) {
        let circle = UIView(frame: CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius))
        circle.backgroundColor = color
        circle.layer.cornerRadius = radius
        circle.layer.masksToBounds = true
        
    }
    
    
//    
//    class func circleWithColor(color: UIColor, radius: CGFloat) -> UIView {
//        let circle = UIView(frame: CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius))
//        circle.backgroundColor = color
//        circle.layer.cornerRadius = radius
//        circle.layer.masksToBounds = true
//        
//        return circle
//    }
}


/*
class CustomCircularButton: UIButton {
override init(frame: CGRect) {
super.init(frame: frame)
setup()
}

required init(coder aDecoder: NSCoder) {
super.init(coder: aDecoder)
setup()
}

func setup() {
layer.cornerRadius = frame.size.height / 2.0
layer.borderColor = UIColor(red: 90/255, green: 191/255, blue: 115/255, alpha: 1.0).CGColor
layer.borderWidth = 2
clipsToBounds = true
}
}


*/