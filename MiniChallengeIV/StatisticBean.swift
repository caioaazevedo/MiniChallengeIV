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
    var id: UUID
    var focusTime: Timer
    var lostFocusTime: Timer
    var restTime: Timer
    var qtdLostFocus: Int
}
