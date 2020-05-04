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
    /// - Parameter taskBean: A object of type TaskBean
    /// - Returns: Boolean if the project was saved
    func createTask(taskBean: TaskBean, completion: (TaskCD?, String?) -> Void){
        
        let taskCD = TaskCD(context: self.context)
        taskCD.descriptionTask = taskBean.description
        taskCD.uuid = taskBean.uuid
        taskCD.state = false
        
        do {
            try context.save()
            completion(taskCD, nil)
        }catch let error as NSError {
            print("Error in ProjectDAO create function: \(error)")
            completion(nil, "Error in ProjectDAO create function: \(error)")
        }
    }
    /// Retrieves a list of tasks
    /// - Returns:  List of tasks
    func retrieve(completion: ([TaskBean]?, String?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskCD")
        var tasks: [TaskBean] = []
        do {
            let fechedTasks = try context.fetch(fetchRequest)
            guard let tasksCD = fechedTasks as? [NSManagedObject] else {
                return completion(nil, "Error in Retrieve function projectDAO")
            }
            
            for task in tasksCD {
                tasks.append(convertBean(task: task))
            }
            completion(tasks, nil)
        }catch let error as NSError {
            print("Error in CDService read function: \(error)")
            completion(nil, "Error in Retrieve function projectDAO")
        }
    }
    
    /// Updates a task in database with DAO
    /// - Parameter taskBean: Task to update
    /// - Returns: Boolean if the project was updated
    func updateTask(taskBean: TaskBean, completion: (Bool, String?) -> Void){
        taskBean.taskCD?.descriptionTask = taskBean.description
        taskBean.taskCD?.state = taskBean.state
        do {
            try context.save()
            completion(true, nil)
        }catch {
            completion(false, "Error in Update function projectDAO")
        }
    }
    
    /// Delete a task in database with DAO
    /// - Parameter uuid: UUID that identifies task
    /// - Returns: Boolean if the task was deleted
    func deleteTask(uuid: UUID, completion: (Bool, String?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskCD")
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid.uuidString)
        
        do {
            let objects = try self.context.fetch(fetchRequest)
            
            guard let object = objects as? [NSManagedObject], objects.count > 0 else{
                completion(false, "Object to delete not found")
                return
            }
            
            context.delete(object[0])
            try context.save()
            
            completion(true, nil)
        }catch{
            completion(false, "Error in delete function ProjectDAO")
        }
    }
    
    func convertBean(task: NSManagedObject) -> TaskBean{
        let uuid = task.value(forKey: "uuid") as! UUID
        let description = task.value(forKey: "descriptionTask") as! String
        let state = task.value(forKey: "state") as! Bool
        
        let taskBean = TaskBean(uuid: uuid, description: description, state: state, taskCD: task as? TaskCD)
        return taskBean
    }

    
   
}
