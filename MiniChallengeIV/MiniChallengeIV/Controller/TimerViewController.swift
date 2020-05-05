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
    let timeTracker = TimeTrackerBO()
    var lostTimeFocus: LostTimeFocusBO?
    //Properties
    ///the validation for the minimum value
    var minimumDecrement: Int{
        //TODO: switch 0 for a generic number
        return timeTracker.configTime - 5  < 15 ? 15 : timeTracker.configTime - 5
    }
    ///the validation for the maximum value
    var maximumDecrement: Int{
        //TODO: switch 60 for a generic number
        return timeTracker.configTime + 5  > 60 ? 60 : timeTracker.configTime + 5
    }
    
    //Buttons, Labels
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var timeConfigButtons: [UIButton]!
    @IBOutlet weak var stateLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timerLabel.text = String(format: "%02i:00", timeTracker.configTime)
        
        self.lostTimeFocus = LostTimeFocusBO(timer: timeTracker)
        
        /// Get Scene Deleegate
        let scene = UIApplication.shared.connectedScenes.first
        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            sd.timer = self.timeTracker
            sd.lostTimeFocus = self.lostTimeFocus
        }
    }
    
    //MARK: START TIMER
    @IBAction func startTimer(_ sender: UIButton) {
        if timeTracker.timer.isValid { // If it's running it stops instead
            stopTimer(sender)
            return
        }
        sender.setTitle("Stop", for: .normal)
        
        timeTracker.startTimer {time, hasEnded in
            self.timerLabel.text = time
            if hasEnded{ // Focus timer ended
                sender.setTitle("Start", for: .normal)
                self.stateLabel.text = self.timeTracker.state.rawValue
                self.setConfigurationButtons()
            }
        }
        setConfigurationButtons()
    }
    
    //MARK: STOP TIMER
    func stopTimer(_ sender: UIButton) {
        sender.setTitle("Start", for: .normal)
        
        timeTracker.stopTimer(){
            //TODO: Message for when the user gives up
            self.stateLabel.text = self.timeTracker.state.rawValue
            self.timerLabel.text = String(format: "%02i:00", self.timeTracker.configTime)
        }
        setConfigurationButtons()
    }
    
    
    ///Increment timer for the count down
    @IBAction func incrementTimer(_ sender: Any) {
        timeTracker.configTime = maximumDecrement
        timerLabel.text = String(format: "%02i:00", timeTracker.configTime)
    }
    ///Decrement timer for the count down
    @IBAction func decrementTimer(_ sender: Any) {
        timeTracker.configTime = minimumDecrement
        timerLabel.text = String(format: "%02i:00", timeTracker.configTime)
    }
    
    ///Method for disabling the buttons that are configuring the Timer
    func setConfigurationButtons(){
        let value = timeTracker.state == .focus ? true : false
        for button in timeConfigButtons{
            button.isEnabled = value
        }
    }
    
}
