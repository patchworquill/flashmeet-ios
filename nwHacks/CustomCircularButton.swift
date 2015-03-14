//
//  CustomCircularButton.swift
//  nwHacks
//
//  Created by Douglas Bumby on 14/03/2015.
//  Copyright (c) 2015 Andrew Richardson. All rights reserved.
//

import UIKit

@IBDesignable
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
