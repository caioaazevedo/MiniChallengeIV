//
//  NSLayoutConstraint.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 14/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

@IBDesignable
extension NSLayoutConstraint {
    
    @IBInspectable
    var iPhone4S: CGFloat {
        get { self.constant }
        set {
            if Device.deviceSize == .i3_5Inch {
                self.constant = newValue
            }
        }
    }
    
    @IBInspectable
    var iPhoneSE: CGFloat {
        get { self.constant }
        set {
            if Device.deviceSize == .i4Inch {
                self.constant = newValue
            }
        }
    }
    
    @IBInspectable
    var iPhone8: CGFloat {
        get { self.constant }
        set {
            if Device.deviceSize == .i4_7Inch {
                self.constant = newValue
            }
        }
    }
    
    @IBInspectable
    var iPhone8Plus: CGFloat {
        get { self.constant }
        set {
            if Device.deviceSize == .i5_5Inch {
                self.constant = newValue
            }
        }
    }
    
    @IBInspectable
    var iPhone11Pro: CGFloat {
        get { self.constant }
        set {
            if Device.deviceSize == .i5_8Inch {
                self.constant = newValue
            }
        }
    }
    
    @IBInspectable
    var iPhone11: CGFloat {
        get { self.constant }
        set {
            if Device.deviceSize == .i6_1Inch {
                self.constant = newValue
            }
        }
    }
    
    @IBInspectable
    var iPhone11Max: CGFloat {
        get { self.constant }
        set {
            if Device.deviceSize == .i6_5Inch {
                self.constant = newValue
            }
        }
    }
    
}
