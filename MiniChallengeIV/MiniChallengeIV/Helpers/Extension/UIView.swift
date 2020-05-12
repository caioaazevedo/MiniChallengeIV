//
//  UIView.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 11/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    @IBInspectable
    var alphaValue: CGFloat {
        get {
            self.alpha * 100
        }
        set {
            self.alpha = newValue / 100
        }
    }
    
    @IBInspectable
    var colorValue: UIColor? {
        get {
            self.backgroundColor
        }
        set {
            self.backgroundColor = newValue
        }
    }
}
