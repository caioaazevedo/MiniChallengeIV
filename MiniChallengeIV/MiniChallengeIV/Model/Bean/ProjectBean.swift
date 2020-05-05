//
//  ProjectBean.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 28/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

/// Model of a project
struct ProjectBean {
    var uuid: UUID
    var name: String
    var color: UIColor
    var time: Int
    var projectCD: ProjectCD? = nil
    var tasks: [TaskBean] = []
    
//    init(uuid: UUID, name: String, color: UIColor, time: Int){
//        self.uuid = uuid
//        self.name = name
//        self.color = color
//        self.time = time
//    }
//    
//    init(uuid: UUID, name: String, color: UIColor, time: Int, projectCD: ProjectCD, tasks: [TaskBean]){
//        self.uuid = uuid
//        self.name = name
//        self.color = color
//        self.time = time
//        self.projectCD = projectCD
//        self.tasks = tasks
//    }
    
}
