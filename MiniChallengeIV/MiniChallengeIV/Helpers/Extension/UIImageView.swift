//
//  UIImageView.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 15/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

@IBDesignable
extension UIImageView {
    
    @IBInspectable
    var iPhone8Below: UIImage? {
        get {
            self.image
        }
        set {
            if Device.deviceSize.rawValue <= 3 {
                self.image = newValue
            }
        }
    }
}
