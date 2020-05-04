//
//  StatisticsBO.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 28/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

class StatisticBO {
    private var statisticDAO = StatisticDAO()
        
//MARK:- Initializer
    init() {}
    
//MARK:- Functions
    /// Bisiness Object
    
    /// Description: function conform and create statistics in the database
    /// - Parameter statistics: the model of statistic to save
    func createStatistic(id: UUID, focusTime: Int, lostFocusTime: Int, restTime: Int, qtdLostFocus: Int, completion: (Bool) -> Void) {
        
        /// Call cration function of statisticDAO to communicate with database
        let statistic = Statistic(id: id, focusTime: focusTime, lostFocusTime: lostFocusTime, restTime: restTime, qtdLostFocus: qtdLostFocus)
        statisticDAO.createStatistic(statistics: statistic, completion: { result, _ in
            completion(result)
        })
    }
    
    /// Description: function conform and update statistics in the database
    /// - Parameter statistics: the model of statistic to update
    func updateStatistic(statistics: Statistic, completion: (Bool) -> Void) {
        
        /// Call update function of statisticDAO to communicate with database
        statisticDAO.updateStatistic(statistics: statistics, completion: { result,_ in
            completion(result)
        })
    }
    
    /// Description: function fetch statistic from database
    func retrieveStatistic(completion: ([Statistic]?) -> Void) {
        
        /// Call cration function of statisticDAO to communicate with database
        statisticDAO.retrieveStatistic(completion: {result,_ in
            completion(result)
        })
    }
}
