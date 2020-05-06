//
//  ProjectDAO.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 28/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ProjectDAO {
    let context = CDManager.shared.persistentContainer.viewContext
    
    /// Create an object of type Project in CoreData
    /// - Parameter project: An project
    /// - Returns: Boolean if the project was created in the data base
    func create(project: Project, completion: (Result<Bool, ValidationError>)  -> Void){
        let projectCD = ProjectCD(context: self.context)
        projectCD.name = project.name
        projectCD.id = project.id
        projectCD.time = Int32(project.time)
        
        guard let color = project.color.toHex else {
            return completion(.failure(.errorToCreate("Project")))
        }
        
        projectCD.color = color
        
        do {
            try context.save()
            completion(.success(true))
        }catch{
            completion(.failure(.errorToCreate("Project")))
        }
    }
    
    /// Performs the search for projects at CoreData
    /// - Returns: List of projects
    func retrieve(completion: (Result<[Project], ValidationError>) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProjectCD")
        var projects: [Project] = []
        do {
            let fechedObjects = try context.fetch(fetchRequest)
            guard let projectsCD = fechedObjects as? [NSManagedObject] else {
                return completion(.failure(.errorToRetrieve("Project")))
            }
            
            for project in projectsCD {
                projects.append(convert(project: project))
            }
            completion(.success(projects))
        }catch {
            completion(.failure(.errorToRetrieve("Project")))
        }
    }
    
    /// Updates a project in the CoreData
    /// - Parameter project: Project to update in the CoreData
    /// - Returns: Boolean if the project was updated
    func update(project: Project, completion: (Result<Void, ValidationError>) -> Void){
        project.projectCD?.name = project.name
        project.projectCD?.time = Int32(project.time)
        
        guard let color = project.color.toHex else {
            return completion(.failure(.errorToUpdate("Project")))
        }
        
        project.projectCD?.color = color
        
        do {
            try context.save()
            completion(.success(()))
        }catch {
            completion(.failure(.errorToUpdate("Project")))
        }

    }
    
    /// Updates a project in the CoreData
    /// - Parameter uuid: UUID that identifies the project
    /// - Returns: Boolean if the project was deleted
    func delete(uuid: UUID, completion: (Result<Void, ValidationError>) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProjectCD")
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid.uuidString)
        
        do {
            let objects = try self.context.fetch(fetchRequest)
            
            guard let object = objects as? [NSManagedObject], objects.count > 0 else{
                return completion(.failure(.errorToDelete("Project")))
            }
            
            context.delete(object[0])
            
            try context.save()
            
            completion(.success(()))
        }catch{
            completion(.failure(.errorToDelete("Project")))
        }

    }
    
    func addTask(taskCD: TaskCD, projectCD: ProjectCD, completion: (Result<Void, ValidationError>) -> Void){
        projectCD.tasks = NSSet.init(array: [taskCD])
        do {
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(.errorToAdd("Task")))
        }
    }
    
    func convert(project: NSManagedObject) -> Project{
        let uuid = project.value(forKey: "id") as! UUID
        let name = project.value(forKey: "name") as! String
        let time = project.value(forKey: "time") as! Int64
        let color = project.value(forKey: "color") as! String
        let tasksCD = project.value(forKey: "tasks") as! NSSet
        
        var tasks: [Task] = []
        for task in tasksCD.allObjects{
            tasks.append(convertTask(task: task as! NSManagedObject))
        }

        let project = Project(id: uuid, name: name, color: UIColor(hex: color)! , time: Int(time), projectCD: project as? ProjectCD, tasks: tasks)
        return project
    }
    
    func convertTask(task: NSManagedObject) -> Task{
        let uuid = task.value(forKey: "id") as! UUID
        let description = task.value(forKey: "descriptionTask") as! String
        let state = task.value(forKey: "state") as! Bool
        
        let task = Task(id: uuid, description: description, state: state, taskCD: task as? TaskCD)
        return task
    }
    
}
