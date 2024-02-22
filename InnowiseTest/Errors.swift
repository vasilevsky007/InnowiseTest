//
//  Errors.swift
//  InnowiseTest
//
//  Created by Alex on 21.02.24.
//

import Foundation

enum PersistenceErrors: Error {
    case noUpdatingPokemonInContext
    case noMorePokemonsInContext
    case noImageInContext
}

extension PersistenceErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .noUpdatingPokemonInContext: "Pokemon not found to save its details in Core Data"
            case .noMorePokemonsInContext: "No more pokemons saved on disk. Wait for the internet connection and try to load again"
            case .noImageInContext: "No such image saved on disk. Wait for the internet connection and try to load again"
        }
    }
}
