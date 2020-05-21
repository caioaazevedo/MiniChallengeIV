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
    func createStatistic(id: UUID, focusTime: Int, lostFocusTime: Int, restTime: Int, qtdLostFocus: Int, year: Int, month: Int, completion: (Result<Bool, ValidationError>) -> Void) {
        
        /// Call cration function of statisticDAO to communicate with database
        let statistic = Statistic(id: id, focusTime: focusTime, lostFocusTime: lostFocusTime, restTime: restTime, qtdLostFocus: qtdLostFocus, year: year, month: month)
        statisticDAO.createStatistic(statistics: statistic, completion: { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    /// Description: function conform and update statistics in the database
    /// - Parameter statistics: the model of statistic to update
    func updateStatistic(statistics: Statistic, completion: (Result<Void, ValidationError>) -> Void) {
        
        /// Call update function of statisticDAO to communicate with database
        statisticDAO.updateStatistic(statistics: statistics, completion: { result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    /// Description: function fetch statistic from database
    func retrieveStatistic(completion: (Result<[Statistic]?, ValidationError>) -> Void) {
        
        /// Call cration function of statisticDAO to communicate with database
        statisticDAO.retrieveStatistic(completion: {result in
            switch result {
            case .success(let statistic):
                completion(.success(statistic))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    /// Description: Function to call the retrieve Statistics Dao Function searching by month and year
    /// - Parameters:
    ///   - month: search month
    ///   - year: search yaer
    ///   - completion: return the Statistic or a validation Error
    func retrieveStatisticPerMonth(month: Int32, year: Int32, completion: (Result<Statistic?, ValidationError>) -> Void) {
        
        /// Call retrieve function per month of statisticDAO to communicate with database
        statisticDAO.retrieveStatisticPerMonth(month: month, year: year, completion: {result in
            switch result {
            case .success(let statistic):
                completion(.success(statistic))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
