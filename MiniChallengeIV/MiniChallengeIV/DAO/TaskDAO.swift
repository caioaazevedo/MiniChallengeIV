//
//  TaskDAO.swift
//  MiniChallengeIV
//
//  Created by Carlos Fontes on 30/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation
import CoreData

class TaskDAO {
    
    let context = CDManager.shared.persistentContainer.viewContext

    //MARK:- Functions
    
    /// Create a task on CoreData
    /// - Parameter task: A object of type Task
    /// - Returns: Boolean if the project was saved
    func createTask(task: Task, completion: (Result<TaskCD, ValidationError>) -> Void){
        
        let taskCD = TaskCD(context: self.context)
        taskCD.descriptionTask = task.description
        taskCD.id = task.id
        taskCD.state = false
        
        do {
            try context.save()
            completion(.success(taskCD))
        }catch {
            completion(.failure(.errorToCreate("Task")))
        }
    }
    
    /// Retrieves a list of tasks
    /// - Returns:  List of tasks
    func retrieve(id: UUID,completion: (Result<[Task], ValidationError>) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskCD")
        fetchRequest.predicate = NSPredicate(format: "owner.id == %@", id.uuidString)
        var tasks: [Task] = []
        do {
            let fechedTasks = try context.fetch(fetchRequest)
            guard let tasksCD = fechedTasks as? [NSManagedObject] else {
                return completion(.failure(.errorToRetrieve("Task")))
            }
            
            for task in tasksCD {
                tasks.append(convert(task: task))
            }
            completion(.success(tasks))
        }catch{
            completion(.failure(.errorToRetrieve("Task")))
        }
    }
    
    /// Updates a task in database with DAO
    /// - Parameter task: Task to update
    /// - Returns: Boolean if the project was updated
    func updateTask(task: Task, completion: (Result<Void, ValidationError>) -> Void){
        task.taskCD?.descriptionTask = task.description
        task.taskCD?.state = task.state
        do {
            try context.save()
            completion(.success(()))
        }catch {
            completion(.failure(.errorToUpdate("Task")))
        }
    }
    
    /// Delete a task in database with DAO
    /// - Parameter uuid: UUID that identifies task
    /// - Returns: Boolean if the task was deleted
    func deleteTask(uuid: UUID, completion: (Result<Void, ValidationError>) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskCD")
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid.uuidString)
        
        do {
            let objects = try self.context.fetch(fetchRequest)
            
            guard let object = objects as? [NSManagedObject], objects.count > 0 else{
                completion(.failure(.errorToDelete("Task")))
                return
            }
            
            context.delete(object[0])
            try context.save()
            
            completion(.success(()))
        }catch{
            completion(.failure(.errorToDelete("Task")))
        }
    }
    
    func convert(task: NSManagedObject) -> Task{
        let uuid = task.value(forKey: "id") as! UUID
        let description = task.value(forKey: "descriptionTask") as! String
        let state = task.value(forKey: "state") as! Bool
        
        let task = Task(id: uuid, description: description, state: state, taskCD: task as? TaskCD)
        return task
    }

    
   
}
