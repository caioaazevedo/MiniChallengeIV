//
//  TimerSimulationBO.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 30/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

/// Simulation Timer Class with Atributes
struct TimerSimulationBean : TimerDataProtocol{
    var configTime: Int
    var focusTime: Int
    var lostFocusTime: Int
    var restTime: Int
    var timerStatus: TimerStatus
}

enum TimerStatus {
    case started, resting, paused
}
