//
//  LostTimeFocusBO.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 30/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

class LostTimeFocusBO {
    var enterBackgroundInstant: Date?
    var returnFromBackgroundInstant: Date?
    
    let timer: TimeTrackerBO
    
    init(timer: TimeTrackerBO) {
        self.timer = timer
    }
    
    func enterbackground(){
        if timer.runningState == TimeTrackerState.focus {
            /// Save the moment that enterBackground
            self.enterBackgroundInstant = Date()
            
            print("EnterBackground Instant: \(enterBackgroundInstant)")
            
        } else if timer.runningState == TimeTrackerState.pause {
            /// Local Notification with rest Time as delay
        }
    }
    
    /// Description: Function to recover and update the timer or the esttistics
    func backgroundTimeRecover(){
        guard let returnbackgroundInstant = self.returnFromBackgroundInstant else { return }
        guard let backgroundInstant = self.enterBackgroundInstant else { return }
        
        /// Get  the time the user has been out of the app
        let lostFocusTime = backgroundInstant.distance(to: returnbackgroundInstant)
        
        print("Came Back after : \(lostFocusTime)")
        
        /// If the user has been out more than the time he configured, update database
        let currentTime = Int(lostFocusTime) + timer.lostFocusTime + timer.focusTime
        let currentRestTime = Int(lostFocusTime) + timer.restTime
        
        if (timer.runningState == .focus && currentTime < timer.convertedTimeValue) {
            /// Update lost focus time from timer with the value calculate when returns from background and the configured Time isnt over
            timer.lostFocusTime += (Int(lostFocusTime))
            timer.countDown -= Int(lostFocusTime)
        } else if  (timer.runningState == .pause && currentRestTime < timer.convertedTimeValue){
            /// Update Atributes
            timer.restTime += (Int(lostFocusTime))
            timer.countDown -= Int(lostFocusTime)
        }else {
            if timer.runningState == .pause {
                /// Update Timer - Lost Focus Time
                timer.restTime = timer.convertedTimeValue - timer.restTime
            } else {
                /// Update Timer - Lost Focus Time
                timer.lostFocusTime = timer.convertedTimeValue - timer.focusTime
            }
            ///Stop Timer
            timer.state = timer.changeCicle
            
            timer.countDown = 0
            
            /// Update Estatistics on Database
            timer.updateStatistics()
        }
            
            
            
            
            
            
            
            
         
        
    }
}
