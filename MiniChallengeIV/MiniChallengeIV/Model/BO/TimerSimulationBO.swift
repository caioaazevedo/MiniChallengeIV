//
//  TimerSimulationBO.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 30/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

/// Simulation Class that will need to be replaced
class TimerSimulationBO : TimerUpdates{
    
//MARK:- Atributes
    var timerSimulationBean: TimerSimulationBean
    var statistcsBO: StatisticBO

//MARK:- Initializer
    init() {
        ///Simulating Values that came from Timer
        let configTime = 30*60 //"00:30:00"
        let focusTime = 10*60 //"00:10:00"TimerUpdates
        let lostFocusTime = 0 //"00:00:00"
        let restTime = 0 //"00:00:00"
        
        let tsBean = TimerSimulationBean(configTime: configTime, focusTime: focusTime, lostFocusTime: lostFocusTime, restTime: restTime, timerStatus: .paused)
        self.timerSimulationBean = tsBean
        self.statistcsBO = StatisticBO()
    }

//MARK:- Functions
    /// Description: if the time the user returned was later than the timer configured time, then the Timer data will have to be saved in the statistics
    func updateStatistics(){
        /// Update Statistics  by accumulating timer attributes
    }
}
