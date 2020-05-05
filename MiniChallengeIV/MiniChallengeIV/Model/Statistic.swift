//
//  StatisticsBean.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 28/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

/// Representation structure of database entities
struct Statistic {
    var id: UUID
    var focusTime: Int
    var lostFocusTime: Int
    var restTime: Int
    var qtdLostFocus: Int
    var statisticCD: StatisticCD? = nil
}
