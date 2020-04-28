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
    func create(name: String, color: UIColor) -> Bool {
        guard name.count > 0  else {
            print("Name empty.")
            return false
        }
        
        let projectBean = ProjectBean(uuid: UUID(), name: name, color: color, totalTime: 0)
        
        return projectDAO.create(project: projectBean)
    }
    
    /// Performs the search for projects at DAO
    /// - Returns: List of projects
    func read() -> [ProjectBean] {
        
        return [ProjectBean]()
    }
    
    /// Updates a project in the database with DAO
    /// - Parameter project: Project to update
    /// - Returns: Boolean if the project was updated
    func update(project: ProjectBean) -> Bool {
        
        return false
    }
    
    /// Updates a project in the database with DAO
    /// - Parameter uuid: UUID that identifies the project
    /// - Returns: Boolean if the project was deleted
    func delete(uuid: UUID) -> Bool {
        
        return false
    }
}
