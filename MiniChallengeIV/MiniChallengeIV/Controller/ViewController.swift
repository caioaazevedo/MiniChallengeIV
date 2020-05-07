//
//  ViewController.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 27/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let keyForLaunch = "validateFirstLaunch"
    var launchedBefore: Bool {
        get {
            return UserDefaults.standard.bool(forKey: keyForLaunch)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyForLaunch)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createStatistics()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        performSegue(withIdentifier: "segue", sender: nil)
        performSegue(withIdentifier: "segue", sender: nil)
    }
    
    ///Method for creating statistics for the first time in a device
    func createStatistics(){
        if launchedBefore {return}
        
        let statisticsBO = StatisticBO()
        statisticsBO.createStatistic(id: UUID(), focusTime: 0, lostFocusTime: 0, restTime: 0, qtdLostFocus: 0) { (result) in
            switch result {
                
            case .success(_): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        launchedBefore = true
    }

}
