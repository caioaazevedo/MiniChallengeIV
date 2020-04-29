//
//  TimerViewController.swift
//  MiniChallengeIV
//
//  Created by Fábio Maciel de Sousa on 29/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

///Place holder ViewController
class TimerViewController: UIViewController {
    
    let timeTracker = TimeTracker()

    
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    ///Method for starting the timer or stopping it when active. It's called by input and it updates the view.
    @IBAction func runTimer(_ sender: UIButton) {
        if !timeTracker.isTrackingTime{
            sender.setTitle("Stop", for: .normal)
            timeTracker.startTimer(countDownFrom: 10) {time in
                self.timerLabel.text = time
            }
        }else{
            sender.setTitle("Start", for: .normal)
            timerLabel.text = "00:00"
            timeTracker.stopTimer(){
                //TODO: Message for when the user gives up
            }
        }
    }
    
}
