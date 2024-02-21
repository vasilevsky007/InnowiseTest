//
//  Errors.swift
//  InnowiseTest
//
//  Created by Alex on 21.02.24.
//

import Foundation

enum PersistenceErrors: Error {
    case NoUpdatingPokemonInContext
}

extension PersistenceErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .NoUpdatingPokemonInContext: "Pokemon not found to save its details in Core Data"
        }
    }
}
