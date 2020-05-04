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
    
    /// Create an object of type ProjectBean in CoreData
    /// - Parameter project: An project
    /// - Returns: Boolean if the project was created in the data base
    func create(projectBean: ProjectBean, completion: (Bool, String?) -> Void){
        let projectCD = ProjectCD(context: self.context)
        projectCD.name = projectBean.name
        projectCD.uuid = projectBean.uuid
        projectCD.time = Int32(projectBean.time)
        guard let color = projectBean.color.toHex else { return completion(false, "Error in projectDAO create function")}
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
    func retrieve(completion: ([ProjectBean]?, String?) -> Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProjectCD")
        var projects: [ProjectBean] = []
        do {
            let fechedObjects = try context.fetch(fetchRequest)
            guard let projectsCD = fechedObjects as? [NSManagedObject] else {
                return completion(nil, "Error in Retrieve function projectDAO")
            }
            
            for project in projectsCD {
                projects.append(convertBean(project: project))
            }
            completion(projects, nil)
        }catch {
            completion(nil, "Error in Retrieve function projectDAO")
        }
    }
    
    /// Updates a project in the CoreData
    /// - Parameter project: Project to update in the CoreData
    /// - Returns: Boolean if the project was updated
    func update(projectBean: ProjectBean, completion: (Bool, String?) -> Void){
        projectBean.projectCD?.name = projectBean.name
        projectBean.projectCD?.time = Int32(projectBean.time)
        guard let color = projectBean.color.toHex else { return completion(false, "Error in projectDAO create function")}
        projectBean.projectCD?.color = color
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
    
    func addTask(taskCD: TaskCD, projectCD: ProjectCD, completion: (Bool, String?) -> Void){
        projectCD.tasks = NSSet.init(array: [taskCD])
        do {
            try context.save()
            completion(true, nil)
        }catch{
            completion(false, "Error in addTask function ProjectDAO")
        }
    }
    
    func convertBean(project: NSManagedObject) -> ProjectBean{
        let uuid = project.value(forKey: "uuid") as! UUID
        let name = project.value(forKey: "name") as! String
        let time = project.value(forKey: "time") as! Int64
        let color = project.value(forKey: "color") as! String
        let tasksCD = project.value(forKey: "tasks") as! NSSet
        
        var tasks: [TaskBean] = []
        for task in tasksCD.allObjects{
            tasks.append(convertTaskBean(task: task as! NSManagedObject))
        }

        let projectBean = ProjectBean(uuid: uuid, name: name, color: UIColor(hex: color)! , time: Int(time), projectCD: project as? ProjectCD, tasks: tasks)
        return projectBean
    }
    
    func convertTaskBean(task: NSManagedObject) -> TaskBean{
        let uuid = task.value(forKey: "uuid") as! UUID
        let description = task.value(forKey: "descriptionTask") as! String
        let state = task.value(forKey: "state") as! Bool
        
        let taskBean = TaskBean(uuid: uuid, description: description, state: state, taskCD: task as? TaskCD)
        return taskBean
    }
    
}
