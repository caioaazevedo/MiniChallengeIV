//
//  StatisticsBean.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 28/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

/// Representation structure of database entities
struct StatisticBean {
    var uuid: UUID
    var focusTime: Int // seconds
    var lostFocusTime: Int // seconds
    var restTime: Int // seconds
    var qtdLostFocus: Int // seconds
    var statisticCD: StatisticCD? = nil
}
