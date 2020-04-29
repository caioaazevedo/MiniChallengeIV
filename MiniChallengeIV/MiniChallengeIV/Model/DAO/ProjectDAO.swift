//
//  ProjectDAO.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 28/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

class ProjectDAO {
    
    /// Create an object of type ProjectBean in CoreData
    /// - Parameter project: An project
    /// - Returns: Boolean if the project was created in the data base
    func create(project: ProjectBean) -> Bool {
        
        return false
    }
    
    /// Performs the search for projects at CoreData
    /// - Returns: List of projects
    func read() -> [ProjectBean]? {
        
        return [ProjectBean]()
    }
    
    /// Updates a project in the CoreData
    /// - Parameter project: Project to update in the CoreData
    /// - Returns: Boolean if the project was updated
    func update(project: ProjectBean) -> Bool {
        
        return false
    }
    
    /// Updates a project in the CoreData
    /// - Parameter uuid: UUID that identifies the project
    /// - Returns: Boolean if the project was deleted
    func delete(uuid: UUID) -> Bool {
        
        return false
    }
    
}
