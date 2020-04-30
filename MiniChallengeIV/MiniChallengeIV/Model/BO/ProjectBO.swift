//
//  ProjectBO.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 28/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

/// Project business object
class ProjectBO {
    /// Project data access object
    private var projectDAO = ProjectDAO()
    
    /// Create an object of type ProjectBean with DAO
    /// - Parameters:
    ///   - name: Name of project
    ///   - color: Color of project
    /// - Returns: Boolean if the project was saved
    func create(name: String, color: UIColor?, completion: (Bool, String?) -> Void) {
        guard name.count > 0  else {
            completion(false, "ProjectBO: Name empty.")
            return
        }
                
        let projectBean = ProjectBean(uuid: UUID(), name: name, color: color, totalTime: 0)
        projectDAO.create(project: projectBean) { success, error in
            completion(success, error)
        }
    }
    
    /// Performs the search for projects at DAO
    /// - Returns: List of projects
    func retrieve() -> [ProjectBean] {
        
        return [ProjectBean]()
    }
    
    /// Updates a project in the database with DAO
    /// - Parameter project: Project to update
    /// - Returns: Boolean if the project was updated
    func update(project: ProjectBean, completion: (Bool, String?) -> Void) {
        guard project.name.count > 0  else {
            completion(false, "ProjectBO: Name empty.")
            return
        }
        
        projectDAO.update(project: project) { success, error in
            completion(success, error)
        }
        
    }
    
    /// Updates a project in the database with DAO
    /// - Parameter uuid: UUID that identifies the project
    /// - Returns: Boolean if the project was deleted
    func delete(uuid: UUID, completion: (Bool, String?) -> Void) {
        projectDAO.delete(uuid: uuid) { success, error in
            completion(success, "ProjectBO: Error deleting project.")
        }
    }
}
