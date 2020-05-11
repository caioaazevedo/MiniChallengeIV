//
//  StatisticsDAO.swift
//  MiniChallengeIV
//
//  Created by Caio Azevedo on 28/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation
import CoreData

class StatisticDAO {
    
    let context = CDManager.shared.persistentContainer.viewContext
    //var database
    
//MARK:- Initializer
    init() {}
    
//MARK:- Functions
    ///Database communication
    
    /// Description: function conform and create statistics in the database
    /// - Parameter statistics: the model of statistic to save
    func createStatistic(statistics: Statistic, completion: (Result<Bool, ValidationError>) -> Void){
        let statisticCD = StatisticCD(context: self.context)
        statisticCD.id = statistics.id
        statisticCD.focusTime = Int32(statistics.focusTime)
        statisticCD.lostFocusTime = Int32(statistics.lostFocusTime)
        statisticCD.qtdLostFocus = Int32(statistics.qtdLostFocus)
        statisticCD.restTime = Int32(statistics.restTime)
        statisticCD.year = Int32(statistics.year)
        statisticCD.month = Int32(statistics.month)

        
        do {
            try context.save()
            completion(.success(true))
        }catch{
            completion(.failure(.errorToCreate("Statistic")))
        }
    }
    
    /// Description: function conform and update statistics in the database
    /// - Parameter statistics: the model of statistic to update
    func updateStatistic(statistics: Statistic, completion: (Result<Void, ValidationError>) -> Void){
        guard let staticCD = statistics.statisticCD else {
            return completion(.failure(.errorToUpdate("Statistic")))
        }
        staticCD.focusTime = Int32(statistics.focusTime)
        staticCD.lostFocusTime = Int32(statistics.lostFocusTime)
        staticCD.qtdLostFocus = Int32(statistics.qtdLostFocus)
        staticCD.restTime = Int32(statistics.restTime)
        staticCD.year = Int32(statistics.year)
        staticCD.month = Int32(statistics.month)
        
        do {
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(.errorToUpdate("Statistic")))
        }
    }
    
    /// Description: function fetch statistic to return
    func retrieveStatistic(completion: (Result<[Statistic]?, ValidationError>) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StatisticCD")
        var statistics: [Statistic] = []
        do {
            let fechedObjects = try context.fetch(fetchRequest)
            
            guard let statisticCD = fechedObjects as? [NSManagedObject] else {
                return completion(.failure(.errorToRetrieve("Statistic")))
            }
            
            for statistic in statisticCD {
                statistics.append(convert(statistic: statistic))
            }
            completion(.success(statistics))
            }catch {
                completion(.failure(.errorToRetrieve("Statistic")))
            }
    }
    
    func convert(statistic: NSManagedObject) -> Statistic{
        let id = statistic.value(forKey: "id") as! UUID
        let focusTime = statistic.value(forKey: "focusTime") as! Int
        let lostFocusTime = statistic.value(forKey: "lostFocusTime") as! Int
        let qtdLostFocus = statistic.value(forKey: "qtdLostFocus") as! Int
        let restTime = statistic.value(forKey: "restTime") as! Int
        let year = statistic.value(forKey: "year") as! Int
        let month = statistic.value(forKey: "month") as! Int

        
        let statistic = Statistic(id: id, focusTime: focusTime, lostFocusTime: lostFocusTime, restTime: restTime, qtdLostFocus: qtdLostFocus, year: year, month: month, statisticCD: statistic as? StatisticCD)
        return statistic
    }
}
