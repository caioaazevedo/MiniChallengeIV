//
//  ProjectDAO.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 28/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

class ProjectDAO {
    
    /// List of ProjectBean
    static var list = [ProjectBean]()
        
    /// Create an object of type ProjectBean in CoreData
    /// - Parameter project: An project
    /// - Returns: Boolean if the project was created in the data base
    func create(project: ProjectBean, completion: (Bool, String?) -> Void) {
        ProjectDAO.list.append(project)
        completion(true, nil)
    }
    
    /// Performs the search for projects at CoreData
    /// - Returns: List of projects
    func retrieve() -> [ProjectBean]? {
        
        return [ProjectBean]()
    }
    
    /// Updates a project in the CoreData
    /// - Parameter project: Project to update in the CoreData
    /// - Returns: Boolean if the project was updated
    func update(project: ProjectBean, completion: (Bool, String?) -> Void) {
        
        if let index = ProjectDAO.list.firstIndex(where: { $0.uuid == project.uuid }) {
            ProjectDAO.list.remove(at: index)
            ProjectDAO.list.insert(project, at: index)
            completion(true, nil)
        }
        else {
            completion(false, "ProjectDAO: Project not found.")
        }
        
    }
    
    /// Updates a project in the CoreData
    /// - Parameter uuid: UUID that identifies the project
    /// - Returns: Boolean if the project was deleted
    func delete(uuid: UUID, completion: (Bool, String?) -> Void) {
        
        if let index = ProjectDAO.list.firstIndex(where: { $0.uuid == uuid }) {
            ProjectDAO.list.remove(at: index)
            completion(true, nil)
        }
        else {
            completion(false, "ProjectDAO: Project not found.")
        }
    }
    
}
