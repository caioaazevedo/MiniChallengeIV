//
//  TaskBean.swift
//  MiniChallengeIV
//
//  Created by Carlos Fontes on 30/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

/// Representation structure of database entities
struct Task {
    var uuid: UUID
    var description: String
    var state: Bool
}
