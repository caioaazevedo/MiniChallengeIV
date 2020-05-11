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
    var year: Int
    var month: Int
    var statisticCD: StatisticCD? = nil
}

extension Statistic: Equatable{
    ///adding statistics += statistics
    static func += (lhs: inout Statistic, rhs: Statistic){
        lhs.id = rhs.id
        lhs.focusTime += rhs.focusTime
        lhs.restTime += rhs.restTime
        lhs.lostFocusTime += rhs.lostFocusTime
        lhs.qtdLostFocus += rhs.qtdLostFocus
        lhs.month = rhs.month
        lhs.year = rhs.year
        lhs.statisticCD = rhs.statisticCD
    }
    ///adding statistics += projects
    static func += (lhs: inout Project, rhs: Statistic){
        lhs.time += rhs.focusTime
        lhs.time += rhs.lostFocusTime
        lhs.time += rhs.restTime
    }
}
