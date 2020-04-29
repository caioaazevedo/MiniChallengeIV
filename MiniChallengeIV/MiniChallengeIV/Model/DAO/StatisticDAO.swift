//
//  StatisticsDAO.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 28/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

class StatisticDAO {
    
    //var database
    
//MARK:- Initializer
    init() {}
    
//MARK:- Functions
    ///Database communication
    
    /// Description: function conform and create statistics in the database
    /// - Parameter statisticsBean: the model of statistic to save
    func createStatistic(statisticsBean: StatisticBean) -> Bool{
        
        return false
    }
    
    /// Description: function conform and update statistics in the database
    /// - Parameter statisticsBean: the model of statistic to update
    func updateStatistic(statisticsBean: StatisticBean) -> Bool{
        
        return false
    }
    
    /// Description: function fetch statistic to return
    func readStatistic() -> StatisticBean?{
        
        return nil
    }
}
