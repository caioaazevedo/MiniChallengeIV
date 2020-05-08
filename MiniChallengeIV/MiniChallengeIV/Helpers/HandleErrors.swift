//
//  HandleErrors.swift
//  MiniChallengeIV
//
//  Created by Carlos Fontes on 05/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

enum ValidationError: Error {
    case errorToAdd(String)
    case errorToCreate(String)
    case errorToRetrieve(String)
    
    case errorToUpdate(String)
    case errorToDelete(String)
    case tooShort(String)
}

extension ValidationError: LocalizedError {
    var errorDescription: String? {
        switch self {
            
        case .errorToAdd(let object):
            let format = NSLocalizedString("Error to add %@", comment: "")
            return String(format: format, object)
            
        case .errorToCreate(let object):
            let format = NSLocalizedString("Error to create %@", comment: "")
            return String(format: format, object)
            
        case .errorToRetrieve(let object):
            let format = NSLocalizedString("Error to retrieve %@", comment: "")
            return String(format: format, object)
            
        case .errorToUpdate(let object):
            let format = NSLocalizedString("Error to update %@", comment: "")
            return String(format: format, object)
            
        case .errorToDelete(let object):
            let format = NSLocalizedString("Error to delete %@", comment: "")
            return String(format: format, object)
            
        case .tooShort(let object):
            let format = NSLocalizedString("Your %@ needs to be at least 2 characters long", comment: "")
            return String(format: format, object)
        }
    }
}
