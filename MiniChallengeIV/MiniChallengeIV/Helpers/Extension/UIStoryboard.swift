//
//  UIStoryboard.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 29/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

enum StoryboardID: String {
    case NewProject
    case TimerPopUp
}

enum ViewControllerID: String {
    case NewProjectID, NewProjectID2, TimerPopUpID
}

fileprivate extension UIStoryboard {
    static func load(from storyboard: StoryboardID, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(identifier: identifier)
    }
}

extension UIStoryboard {
    static func loadView(from: StoryboardID, identifier: ViewControllerID) -> UIViewController {
        return load(from: from, identifier: identifier.rawValue)
    }
}


//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        print("tap")
//        view.endEditing(true)
//    }
//}
