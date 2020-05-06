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
    
    /// Create an object of type Project with DAO
    /// - Parameters:
    ///   - name: Name of project
    ///   - color: Color of project
    /// - Returns: Boolean if the project was saved
    func create(name: String, color: UIColor, completion: (Result<Bool, ValidationError>) -> Void) {
        guard name.count > 0  else {
            completion(.failure(.tooShort("Project")))
            return
        }
                
        let project = Project(id: UUID(), name: name, color: color, time: 0)
        projectDAO.create(project: project, completion: { result in
            switch result {
                case .success(_):
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
        })
    }
    
    /// Performs the search for projects at DAO
    /// - Returns: List of projects
    func retrieve(completion: (Result<[Project], ValidationError>) -> Void){
        projectDAO.retrieve(completion: { result in
            switch result {
                
            case .success(let projects):
                completion(.success(projects))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    /// Updates a project in the database with DAO
    /// - Parameter project: Project to update
    /// - Returns: Boolean if the project was updated
    func update(project: Project, completion: (Result<Void, ValidationError>) -> Void) {
        
        guard project.name.count > 0  else {
            completion(.failure(.tooShort("Project")))
            return
        }
        
        projectDAO.update(project: project, completion: { result in
            switch result {

            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        
    }
    
    /// Updates a project in the database with DAO
    /// - Parameter uuid: UUID that identifies the project
    /// - Returns: Boolean if the project was deleted
    func delete(uuid: UUID, completion: (Result<Void, ValidationError>) -> Void) {
        projectDAO.delete(uuid: uuid, completion: { result in
            switch result {
                
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func addTask(taskCD: TaskCD, projectCD: ProjectCD, completion: (Result<Void, ValidationError>) -> Void){
        projectDAO.addTask(taskCD: taskCD, projectCD: projectCD, completion: { result in
            
            switch result {
                
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
