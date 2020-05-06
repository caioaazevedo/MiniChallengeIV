//
//  DatabaseService.swift
//  MiniChallengeIV
//
//  Created by Carlos Fontes on 28/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

protocol DatabaseService {
    func create<T>(object: T)
    func read<T>(object: T)
    func update<T>(object: T)
    func delete<T>(object: T)
}
