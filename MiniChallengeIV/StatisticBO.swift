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
    func createStatistic(statistics: Statistic) {
        
        /// Call cration function of statisticDAO to communicate with database
        let  success = statisticDAO.createStatistic(statistics: statistics)
        
        if success {
            
        } else {
            /// Handle Error
        }
        
    }
    
    /// Description: function conform and update statistics in the database
    /// - Parameter statistics: the model of statistic to update
    func updateStatistic(statistics: Statistic) {
        
        /// Call update function of statisticDAO to communicate with database
        let  success = statisticDAO.updateStatistic(statistics: statistics)
        
        if success {
            
        } else {
            /// Handle Error
        }
    }
    
    /// Description: function fetch statistic from database
    func readStatistic() -> Statistic? {
        
        /// Call cration function of statisticDAO to communicate with database
        if let statistic = statisticDAO.readStatistic() {
            return statistic
        } else {
            /// Handle Error
            
            return nil
        }
    }
}
