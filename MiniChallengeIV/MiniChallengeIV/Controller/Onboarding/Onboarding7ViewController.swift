//
//  Onboarding7ViewController.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 19/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

class Onboarding7ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onClickStart(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "onboardingWasDisplayed")
    }
    
}
