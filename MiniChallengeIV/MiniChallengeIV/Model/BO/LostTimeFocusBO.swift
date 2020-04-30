//
//  LostTimeFocusBO.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 30/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

class LosttTimeFocusBO {
    var enterBackgroundInstant: Date?
    var returnFromBackgroundInstant: Date?
    
    let timer = TimerSimulationBO()
    
    init() { }
    
    func enterbackground(){
        if timer.timerSimulationBean.timerStatus == TimerStatus.started {
            /// Save the moment that enterBackground
            self.enterBackgroundInstant = Date()
            
            print("EnterBackground Instant: \(enterBackgroundInstant)")
            
        } else if timer.timerSimulationBean.timerStatus == TimerStatus.resting{
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
        let timeDifference = Int(lostFocusTime) - timer.timerSimulationBean.configTime
        
        if (timeDifference > 0) {
            /// Update Timer - Lost Focus Time
            timer.timerSimulationBean.lostFocusTime = timer.timerSimulationBean.configTime - timer.timerSimulationBean.focusTime
            
            ///Stop Timer
            timer.timerSimulationBean.timerStatus = .paused
            
            /// Update Estatistics on Database
            timer.updateStatistics()
        } else if timeDifference < timer.timerSimulationBean.restTime {
            /// Timer to rest
            timer.timerSimulationBean.timerStatus = .resting
        } else {
            /// Update lost focus time from timer with the value calculate when returns from background and the configured Time isnt over
            timer.timerSimulationBean.lostFocusTime = (Int(lostFocusTime))
        }
        
    }
}
