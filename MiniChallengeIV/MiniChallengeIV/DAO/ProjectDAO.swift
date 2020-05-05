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
    func create(project: Project, completion: (Bool, String?) -> Void){
        let projectCD = ProjectCD(context: self.context)
        projectCD.name = project.name
        projectCD.id = project.id
        projectCD.time = Int32(project.time)
        guard let color = project.color.toHex else { return completion(false, "Error in projectDAO create function")}
        projectCD.color = color
        
        do {
            try context.save()
            completion(true, nil)
        }catch{
            completion(false, "Error in ProjectDAO create function")
        }
    }
    
    /// Performs the search for projects at CoreData
    /// - Returns: List of projects
    func retrieve(completion: ([Project]?, String?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProjectCD")
        var projects: [Project] = []
        do {
            let fechedObjects = try context.fetch(fetchRequest)
            guard let projectsCD = fechedObjects as? [NSManagedObject] else {
                return completion(nil, "Error in Retrieve function projectDAO")
            }
            
            for project in projectsCD {
                projects.append(convert(project: project))
            }
            completion(projects, nil)
        }catch {
            completion(nil, "Error in Retrieve function projectDAO")
        }
    }
    
    /// Updates a project in the CoreData
    /// - Parameter project: Project to update in the CoreData
    /// - Returns: Boolean if the project was updated
    func update(project: Project, completion: (Bool, String?) -> Void){
        project.projectCD?.name = project.name
        project.projectCD?.time = Int32(project.time)
        guard let color = project.color.toHex else { return completion(false, "Error in projectDAO create function")}
        project.projectCD?.color = color
        do {
            try context.save()
            completion(true, nil)
        }catch {
            completion(false, "Error in Update function projectDAO")
        }

    }
    
    /// Updates a project in the CoreData
    /// - Parameter uuid: UUID that identifies the project
    /// - Returns: Boolean if the project was deleted
    func delete(uuid: UUID, completion: (Bool, String?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProjectCD")
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid.uuidString)
        
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
    
    func addTask(taskCD: TaskCD, projectCD: ProjectCD, completion: (Bool, String?) -> Void){
        projectCD.tasks = NSSet.init(array: [taskCD])
        do {
            try context.save()
            completion(true, nil)
        }catch{
            completion(false, "Error in addTask function ProjectDAO")
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
