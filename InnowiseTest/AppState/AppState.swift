//
//  AppState.swift
//  InnowiseTest
//
//  Created by Alex on 17.02.24.
//

import Foundation

///AppState works as the single source of truth and keeps the state for the entire app, including user’s data, authentication tokens, screen navigation state (selected tabs, presented sheets) and system state (is active / is backgrounded, etc.)
class AppState: ObservableObject, Equatable {
    @Published var userData = UserData()
}

extension AppState {
    /// all data accessible to all views. single source of truth for the entire app
    /// - warning: don't change fields directly, use provided functions!
    struct UserData: Equatable {
        var pokemonsAvailibleCount: Int?
        var pokemons: [Pokemon] = []
        var allPokemonsLoaded: Bool {
            pokemons.count >= pokemonsAvailibleCount ?? 1
        }
        var cacheSize: Int64? = nil
    }
    
    /// used for updating displaying size of data cache
    /// - Parameter size: number of bytes
    @MainActor func changeCacheSize(_ size: Int64?) {
        self.userData.cacheSize = size
    }
    
    /// used for adding new pokemons to ``UserData``
    /// - Parameters:
    ///   - newPokemons: array of new `Pokemon` structs
    ///   - pokemonsAvailibleCount: number of all pokemons availiable for loading
    @MainActor func addPokemons(newPokemons: [Pokemon], pokemonsAvailibleCount: Int) {
        self.userData.pokemonsAvailibleCount = pokemonsAvailibleCount
        self.userData.pokemons.append(contentsOf: newPokemons)
    }
    
    /// used for adding additional information to `Pokemon.Details` struct
    /// - Parameters:
    ///   - details: details struct to add
    ///   - pokemon: pokemon to add this details
    @MainActor func addDetails(_ details: Pokemon.Details, to pokemon: Pokemon) {
        guard let index = self.userData.pokemons.firstIndex(of: pokemon) else { return }
        self.userData.pokemons[index].details = details
    }
    
    @MainActor func clearCurrentPokemons() {
        self.userData.pokemons = []
        self.userData.pokemonsAvailibleCount = nil
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.userData == rhs.userData
}
