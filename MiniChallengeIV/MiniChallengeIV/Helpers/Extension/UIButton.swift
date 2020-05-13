//
//  UIButton.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 12/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

@IBDesignable
extension UIButton {
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            UIColor(cgColor: self.layer.borderColor ?? UIColor().cgColor)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
}
