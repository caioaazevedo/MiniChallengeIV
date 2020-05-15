//
//  UILabel.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 14/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

@IBDesignable
extension UILabel {
    @IBInspectable
    var adjustedValue: CGFloat {
        get { 0 }
        set {
            self.font = UIFont(name: self.font.fontName, size: newValue.adjusted)
        }
    }
}
