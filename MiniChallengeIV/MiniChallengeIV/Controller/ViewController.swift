//
//  ViewController.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 27/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: "segue", sender: nil)
    }

}

