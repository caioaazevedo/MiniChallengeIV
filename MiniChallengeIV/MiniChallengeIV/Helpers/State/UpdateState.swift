//
//  UpdateState.swift
//  MiniChallengeIV
//
//  Created by Carlos Fontes on 19/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation
import GameplayKit
class UpdateState: GKState {
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is NormalState.Type:
            return true
        default:
            return false
        }
    }
    
    override init() {
    }
}
