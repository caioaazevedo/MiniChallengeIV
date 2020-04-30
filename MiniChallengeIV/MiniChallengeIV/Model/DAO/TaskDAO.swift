//
//  TaskDAO.swift
//  MiniChallengeIV
//
//  Created by Carlos Fontes on 30/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation
class TaskDAO {
    
    //MARK:- Functions
    
    /// Create a task on CoreData
    /// - Parameter taskBean: A object of type TaskBean
    /// - Returns: Boolean if the project was saved
    func createTask(taskBean: TaskBean) -> Bool{
        return false
    }
    /// Retrieves a list of tasks
    /// - Returns:  List of tasks
    func retrieve() -> [TaskBean]? {
        return nil
    }
    
    /// Updates a task in database with DAO
    /// - Parameter taskBean: Task to update
    /// - Returns: Boolean if the project was updated
    func updateTask(taskBean: TaskBean) -> Bool {
        return false
    }
    
    /// Delete a task in database with DAO
    /// - Parameter uuid: UUID that identifies task
    /// - Returns: Boolean if the task was deleted
    func deleteTask(uuid: UUID) -> Bool {
        return false
    }
}
