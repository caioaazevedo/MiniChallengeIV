//
//  Device.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 14/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

enum Model: String {
    case
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPhone6            = "iPhone 6",
    iPhone6plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6Splus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    iPhoneXS           = "iPhone XS",
    iPhoneXSMax        = "iPhone XS Max",
    iPhoneXR           = "iPhone XR",
    unrecognized       = "?unrecognized?"
}

enum UIDeviceSize: Int {
    case i3_5Inch
    case i4Inch
    case i4_7Inch
    case i5_5Inch
    case i5_8Inch
    case i6_1Inch
    case i6_5Inch
    case unknown
}

struct Device {
    // Based iPhone11
    static let base: CGFloat = 414
    
    static var ratio: CGFloat {
        UIScreen.main.bounds.width / base
    }
    
    static var deviceSize: UIDeviceSize = {
        let w: Double = Double(UIScreen.main.bounds.width)
        let h: Double = Double(UIScreen.main.bounds.height)
        let screenHeight: Double = max(w, h)
        
        switch screenHeight {
        case 480:
            return .i3_5Inch
        case 568:
            return .i4Inch
        case 667:
            return UIScreen.main.scale == 3.0 ? .i5_5Inch : .i4_7Inch
        case 736:
            return .i5_5Inch
        case 812:
            return .i5_8Inch
        case 896:
            switch UIDevice().type {
            case .iPhoneXSMax:
                return .i6_5Inch
            default:
                return .i6_1Inch
            }
        default:
            return .unknown
        }
        
    }()
}

extension UIDevice {
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
                
            }
        }
        let modelMap : [ String : Model ] = [
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,4" : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8plus,
            "iPhone10,5" : .iPhone8plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            return model
        }
        return Model.unrecognized
    }
}

extension CGFloat {
  var adjusted: CGFloat {
    return self * Device.ratio
  }
}

extension Double {
  var adjusted: CGFloat {
    return CGFloat(self) * Device.ratio
  }
}

extension Int {
  var adjusted: CGFloat {
    return CGFloat(self) * Device.ratio
  }
}
