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
    /// - Parameter statisticsBean: the model of statistic to save
    func createStatistic(statisticsBean: StatisticBean, completion: (Bool, String?) -> Void){
        let statisticCD = StatisticCD(context: self.context)
        statisticCD.uuid = statisticsBean.uuid
        statisticCD.focusTime = Int32(statisticsBean.focusTime)
        statisticCD.lostFocusTime = Int32(statisticsBean.lostFocusTime)
        statisticCD.qtdLostFocus = Int32(statisticsBean.qtdLostFocus)
        statisticCD.restTime = Int32(statisticsBean.restTime)
        
        do {
            try context.save()
            completion(true, nil)
        }catch{
            completion(false, "Error in Create function on StatisticDAO")
        }
    }
    
    /// Description: function conform and update statistics in the database
    /// - Parameter statisticsBean: the model of statistic to update
    func updateStatistic(statisticsBean: StatisticBean, completion: (Bool, String?) -> Void){
        guard let staticCD = statisticsBean.statisticCD else {
            return completion(false, "Error in Update function on StatisticDAO")
        }
        staticCD.focusTime = Int32(statisticsBean.focusTime)
        staticCD.lostFocusTime = Int32(statisticsBean.lostFocusTime)
        staticCD.qtdLostFocus = Int32(statisticsBean.qtdLostFocus)
        staticCD.restTime = Int32(statisticsBean.restTime)
        
        do {
            try context.save()
            completion(true, nil)
        }catch {
            completion(false, "Error in Update function on StatisticDAO")
        }
    }
    
    /// Description: function fetch statistic to return
    func retrieveStatistic(completion: ([StatisticBean]?, String?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StatisticCD")
        var statistics: [StatisticBean] = []
        do {
            let fechedObjects = try context.fetch(fetchRequest)
            
            guard let statisticCD = fechedObjects as? [NSManagedObject] else {
                return completion(nil, "Error in Retrieve function on StatisticDAO")
            }
            
            for statistic in statisticCD {
                statistics.append(convertBean(statistic: statistic))
            }
            completion(statistics, nil)
        }catch {
            completion(nil, "Error in Retrieve function projectDAO")
        }
    }
    
    func convertBean(statistic: NSManagedObject) -> StatisticBean{
        let uuid = statistic.value(forKey: "uuid") as! UUID
        let focusTime = statistic.value(forKey: "focusTime") as! Int
        let lostFocusTime = statistic.value(forKey: "lostFocusTime") as! Int
        let qtdLostFocus = statistic.value(forKey: "qtdLostFocus") as! Int
        let restTime = statistic.value(forKey: "restTime") as! Int
        
        let statistic = StatisticBean(uuid: uuid, focusTime: focusTime, lostFocusTime: lostFocusTime, restTime: restTime, qtdLostFocus: qtdLostFocus, statisticCD: statistic as? StatisticCD)
        return statistic
    }
}
