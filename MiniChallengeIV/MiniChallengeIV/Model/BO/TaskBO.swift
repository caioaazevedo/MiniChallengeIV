//
//  TaskBO.swift
//  MiniChallengeIV
//
//  Created by Carlos Fontes on 30/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

class TaskBO {
    
    //MARK:- Atributes
    private var taskDAO = TaskDAO()
    
    //MARK:- Functions
    
    /// Create a task of type TaskBean with DAO
    /// - Parameter description: Description of task
    /// - Returns: Boolean if the task was saved
    func create(description: String) -> Bool{
        
        let taskBean = TaskBean(uuid: UUID(), description: description, state: false)
        return taskDAO.createTask(taskBean: taskBean)
    }
    
    /// Retrieves a list of tasks
    /// - Returns: List of tasks
    func retrieve() -> [TaskBean]? {
        
        let tasks = taskDAO.retrieve()
        return tasks
    }
    
    /// Updates a task in database with DAO
    /// - Parameter taskBean: Task to update
    /// - Returns: Boolean if the project was updated
    func update(taskBean: TaskBean) -> Bool {
        return false
    }
    
    /// Delete a task in database with DAO
    /// - Parameter uuid: UUID that identifies task
    /// - Returns: Boolean if the task was deleted
    func delete(uuid: UUID) -> Bool {
        return false
    }
}
