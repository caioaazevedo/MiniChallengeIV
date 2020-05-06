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
    func create(description: String, completion: (Result<Void, ValidationError>) -> Void){
        let task = Task(id: UUID(), description: description, state: false)
        
        taskDAO.createTask(task: task, completion: { result in
            switch result {
                
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    /// Retrieves a list of tasks
    /// - Returns: List of tasks
    func retrieve(completion: (Result<[Task], ValidationError>) -> Void){
        taskDAO.retrieve(completion: { result in
            switch result {
                
            case .success(let tasks):
                completion(.success(tasks))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    /// Updates a task in database with DAO
    /// - Parameter task: Task to update
    /// - Returns: Boolean if the project was updated
    func update(task: Task, completion: (Result<Void, ValidationError>) -> Void) {
        taskDAO.updateTask(task: task, completion: { result in
            switch result {
                
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    /// Delete a task in database with DAO
    /// - Parameter uuid: UUID that identifies task
    /// - Returns: Boolean if the task was deleted
    func delete(uuid: UUID, completion: (Result<Void, ValidationError>) -> Void){
        taskDAO.deleteTask(uuid: uuid, completion: { result in
            switch result {
                
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
