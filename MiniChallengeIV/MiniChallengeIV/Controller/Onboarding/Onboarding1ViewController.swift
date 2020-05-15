//
//  Onboarding1ViewController.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 14/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

class Onboarding1ViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if Device.deviceSize.rawValue <= 3 {
            backgroundImage.image = #imageLiteral(resourceName: "Onboarding1Square")
        }
    }
    
}
