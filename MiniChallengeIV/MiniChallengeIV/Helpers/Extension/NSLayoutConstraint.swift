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
    
//    @IBInspectable
//    var iPhone11: CGFloat {
//        get { self.constant }
//        set {
//            if Device.deviceSize == .i6_1Inch {
//                self.constant = newValue
//            }
//        }
//    }
    
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

@IBDesignable
extension UIViewController{
    @IBInspectable
    var adapt: Bool {
        get { return false }
        set {
            if newValue{
                adaptAutoLayout()
            }
        }
    }
    
    //Adapt auto layout according to device
    func adaptAutoLayout(){
        //Get all screen sizes
        let screenElements = self.view.subviewsRecursive()
        let constraints = screenElements.map{$0.constraints}.joined()
        for constraint in constraints {
            if constraint.identifier == "height" {
                constraint.constant = constraint.constant.scaledHeight
            } else if constraint.identifier == "width" {
                constraint.constant = constraint.constant.scaledWidth
            }
        }
        
        //Labels
        guard let labels = screenElements.filter({$0.isKind(of: UILabel.self)}) as? [UILabel] else {return}
        guard let buttons = screenElements.filter({$0.isKind(of: UIButton.self)}) as? [UIButton] else {return}
        
        for label in labels{
            label.font = label.font.withSize(label.font.pointSize.scaledHeight)
        }
        
        for button in buttons{
            button.titleLabel?.font = button.titleLabel?.font.withSize((button.titleLabel?.font.pointSize.scaledHeight)!)
        }
    }
}
