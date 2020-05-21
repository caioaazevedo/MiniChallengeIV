//
//  NormalState.swift
//  MiniChallengeIV
//
//  Created by Carlos Fontes on 19/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation
import GameplayKit

class NormalState: GKState {
    
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is SaveState.Type:
            return true
        
        case is UpdateState.Type:
            return true
        default:
            return false
        }
    }
    
    override init() {
    }
}
