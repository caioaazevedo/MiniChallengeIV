//
//  UITextField.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 12/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

@IBDesignable
extension UITextField {
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
    var borderColor: UIColor {
        get {
            UIColor(cgColor: self.layer.borderColor ?? UIColor().cgColor)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var leftPadding: CGFloat {
        get {
            self.leftView?.frame.size.width ?? CGFloat()
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable
    var rightPadding: CGFloat {
        get {
            self.rightView?.frame.size.width ?? CGFloat()
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
    
    @IBInspectable
    var localizedKey: String? {
        get {
            ""
        }
        set {
            guard let key = placeholder else {return}
            let localizedString = NSLocalizedString(key, comment: "")
            placeholder = localizedString
        }
    }
    
    func clearStrikeThrough(){
        if let text = self.text {
           let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
            attributeString.setAttributes([:], range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
    
    func addStrikeThrough(){
        
        if let text = self.text {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
}
