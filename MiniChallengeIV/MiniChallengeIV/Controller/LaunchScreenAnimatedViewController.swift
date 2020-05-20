//
//  LaunchScreenAnimatedViewController.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 20/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

class LaunchScreenAnimatedViewController: UIViewController {

    @IBOutlet weak var ringView: AnimatedRingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initAnimate()
    }
    
    private func initAnimate() {
        delay(1) {
            self.ringView.animateRing(From: 0, FromAngle: 0, To: 1, Duration: 1.25, timing: .easeInEaseOut)
            self.delay(2) {
                self.performSegue(withIdentifier: "projects", sender: self)
            }
        }
    }
    
    private func delay(_ seconds: TimeInterval, completion: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }

}
