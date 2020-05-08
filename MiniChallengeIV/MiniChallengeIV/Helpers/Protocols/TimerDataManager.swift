//
//  TimerData.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 30/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

protocol TimerDataProtocol {
    var configTime: Int { get set }
    var focusTime: Int { get set }
    var lostFocusTime: Int { get set }
    var restTime: Int { get set }
    var state: TimeTrackerState { get set }
    var runningState: TimeTrackerState { get set }
    var convertedTimeValue: Int { get }
    var countDown: Int { get set }
    var changeCicle: TimeTrackerState { get }
    
    func updateStatistics()
}
