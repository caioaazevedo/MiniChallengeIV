//
//  ProjectBean.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 28/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

/// Model of a project
struct Project {
    var id: UUID
    var name: String
    var color: UIColor
    var time: Int
    var projectCD: ProjectCD? = nil
    var tasks: [Task]? = nil
}
