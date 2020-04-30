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
    
    //Atributes
    let timeTracker = TimeTracker()
    var timeValue = 25
    
    //Properties
    ///the validation for the minimum value
    var minimumDecrement: Int{
        //TODO: switch 0 for a generic number
        return timeValue - 5  < 15 ? 15 : timeValue - 5
    }
    ///the validation for the maximum value
    var maximumDecrement: Int{
        //TODO: switch 60 for a generic number
        return timeValue + 5  > 60 ? 60 : timeValue + 5
    }
    
    //Buttons
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var timeConfigButtons: [UIButton]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timerLabel.text = String(format: "%02i:00", timeValue)
    }
    
    
    ///Method for starting the timer or stopping it when active. It's called by input and it updates the view.
    @IBAction func runTimer(_ sender: UIButton) {
        if !timeTracker.isTrackingTime{
            sender.setTitle("Stop", for: .normal)
            timeTracker.startTimer(countDownFrom: timeValue) {time in
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
    
    ///Increment timer for the count down
    @IBAction func incrementTimer(_ sender: Any) {
        timeValue = maximumDecrement
        timerLabel.text = String(format: "%02i:00", timeValue)
    }
    ///Decrement timer for the count down
    @IBAction func decrementTimer(_ sender: Any) {
        timeValue = minimumDecrement
        timerLabel.text = String(format: "%02i:00", timeValue)
    }
    
    ///Method for disabling the buttons that are configuring the Timer
    func disableConfigurationButtons(){
        for button in timeConfigButtons{
            button.isEnabled = false
        }
    }
    
}
