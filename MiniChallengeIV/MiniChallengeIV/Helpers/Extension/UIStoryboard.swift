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
}

enum ViewControllerID: String {
    case NewProjectID, NewProjectID2
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
