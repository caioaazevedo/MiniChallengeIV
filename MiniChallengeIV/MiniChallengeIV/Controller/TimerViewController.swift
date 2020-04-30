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
    
    //Properties
    ///the validation for the minimum value
    var minimumDecrement: Int{
        //TODO: switch 0 for a generic number
        return timeTracker.timeValue - 5  < 15 ? 15 : timeTracker.timeValue - 5
    }
    ///the validation for the maximum value
    var maximumDecrement: Int{
        //TODO: switch 60 for a generic number
        return timeTracker.timeValue + 5  > 60 ? 60 : timeTracker.timeValue + 5
    }
    
    //Buttons, Labels
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var timeConfigButtons: [UIButton]!
    @IBOutlet weak var stateLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timerLabel.text = String(format: "%02i:00", timeTracker.timeValue)
        ///Remove
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            sd.timer = self.timeTracker
        }
    }
    
    
    ///Method for starting the timer or stopping it when active. It's called by input and it updates the view.
    @IBAction func runTimer(_ sender: UIButton) {
        if timeTracker.state != .running{
            sender.setTitle("Stop", for: .normal)
            timeTracker.startTimer {time, ended in
                self.timerLabel.text = time
                if ended{
                    sender.setTitle("Start", for: .normal)
                    self.stateLabel.text = self.timeTracker.state.rawValue
                    self.setConfigurationButtons()
                }
            }
        }else{
            sender.setTitle("Start", for: .normal)
            timeTracker.stopTimer(){
                //TODO: Message for when the user gives up
                self.stateLabel.text = self.timeTracker.state.rawValue
                self.timerLabel.text = String(format: "%02i:00", self.timeTracker.timeValue)
            }
        }
        setConfigurationButtons()
    }
    
    ///Increment timer for the count down
    @IBAction func incrementTimer(_ sender: Any) {
        timeTracker.timeValue = maximumDecrement
        timerLabel.text = String(format: "%02i:00", timeTracker.timeValue)
    }
    ///Decrement timer for the count down
    @IBAction func decrementTimer(_ sender: Any) {
        timeTracker.timeValue = minimumDecrement
        timerLabel.text = String(format: "%02i:00", timeTracker.timeValue)
    }
    
    ///Method for disabling the buttons that are configuring the Timer
    func setConfigurationButtons(){
        let value = timeTracker.state == .focus ? true : false
        for button in timeConfigButtons{
            button.isEnabled = value
        }
    }
    
}
