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
    
    /// Create a task of type Task with DAO
    /// - Parameter description: Description of task
    /// - Returns: Boolean if the task was saved
    func create(description: String, completion: (TaskCD?) -> Void){
        let task = Task(id: UUID(), description: description, state: false)
        
        taskDAO.createTask(task: task, completion: { res,_ in
            completion(res)
        })
    }
    
    /// Retrieves a list of tasks
    /// - Returns: List of tasks
    func retrieve(completion: ([Task]?) -> Void){
        taskDAO.retrieve(completion: { result,_ in
           completion(result)
        })
    }
    
    /// Updates a task in database with DAO
    /// - Parameter task: Task to update
    /// - Returns: Boolean if the project was updated
    func update(task: Task, completion: (Bool) -> Void) {
        taskDAO.updateTask(task: task, completion: { result, _ in
            completion(result)
        })
    }
    
    /// Delete a task in database with DAO
    /// - Parameter uuid: UUID that identifies task
    /// - Returns: Boolean if the task was deleted
    func delete(uuid: UUID, completion: (Bool) -> Void){
        taskDAO.deleteTask(uuid: uuid, completion: { result, _ in
            completion(result)
        })
    }
}
