//
//  CGFloat.swift
//  MiniChallengeIV
//
//  Created by Fábio Maciel de Sousa on 15/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation
import UIKit


extension CGFloat {

    public var scaledHeight: CGFloat {
        switch UIScreen.main.bounds.size.height {
        case 480://Iphone 4
            return (self*480)/896
        case 568://SE1
            return (self*568)/896
        case 667://SE2
            return (self*667)/896
        case 736://Iphone 8
            return (self*736)/896
        case 896://Iphone 11
            return self
        default:
            return self
        }
    }
    
    public var scaledWidth: CGFloat {
        switch UIScreen.main.bounds.size.width {
        case 320://Iphone 4 / SE1
            return (self*320)/414
        case 375://SE2
            return (self*375)/414
        case 414://Iphone 8 / Iphone 11
            return self
        default:
            return self
        }
    }
}

extension UIView {

    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }

}
