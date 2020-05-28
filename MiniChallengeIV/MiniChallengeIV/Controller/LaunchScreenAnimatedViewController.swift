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
    
    private var canNext = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ProjectBO().retrieve { _ in
            goToProjectViewController()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initAnimate()
    }
    
    private func initAnimate() {
        delay(1) {
            self.ringView.animateRing(From: 0, FromAngle: 0, To: 1, Duration: 1.25, timing: .easeInEaseOut)
            self.delay(2) {
                self.canNext = true
                self.goToProjectViewController()
            }
        }
    }
    
    private func goToProjectViewController() {
        guard canNext else { return }
        
        guard UserDefaults.standard.bool(forKey: "onboardingWasDisplayed") else {
            goToOnboardingViewController()
            return
        }
        
        performSegue(withIdentifier: "projects", sender: self)
    }
    
    private func goToOnboardingViewController() {
        
        if let onboardingVC = UIStoryboard.loadView(from: .Onboarding, identifier: .VC) as? OnboardingPagerViewController {
            onboardingVC.modalTransitionStyle = .crossDissolve
            onboardingVC.modalPresentationStyle = .overCurrentContext
            
            self.present(onboardingVC, animated: true)
        }
    }
    
    private func delay(_ seconds: TimeInterval, completion: @escaping() -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }

}
