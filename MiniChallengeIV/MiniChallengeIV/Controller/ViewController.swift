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
        createStatistics()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        performSegue(withIdentifier: "segue", sender: nil)
        performSegue(withIdentifier: "onboarding", sender: nil)
    }
    
    ///Method for creating statistics for the first time in a device
    func createStatistics(){
        //get date
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.yyyy"
        let key = formatter.string(from: date)
        
        var startedNewMonth: Bool {
            get {
                return UserDefaults.standard.bool(forKey: key)
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
        //Check if the date regard a new month
        if startedNewMonth {return}
        
        //Convert it to int
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)

        guard let year = components.year,
            let month = components.month else {return}
        //implement it in statistics
        let statisticsBO = StatisticBO()
        statisticsBO.createStatistic(id: UUID(), focusTime: 0, lostFocusTime: 0, restTime: 0, qtdLostFocus: 0, year: year, month: month) { (result) in
            switch result {
                
            case .success(_): break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        //set the month to checked
        startedNewMonth = true
    }

}
