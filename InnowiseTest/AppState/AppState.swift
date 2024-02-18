//
//  AppState.swift
//  InnowiseTest
//
//  Created by Alex on 17.02.24.
//

import Foundation

///AppState works as the single source of truth and keeps the state for the entire app, including user’s data, authentication tokens, screen navigation state (selected tabs, presented sheets) and system state (is active / is backgrounded, etc.)
class AppState: ObservableObject, Equatable {
    @Published private(set) var userData = UserData()
}

extension AppState {
    struct UserData: Equatable {
        //some data accessible to all views. single
        var pokemonsAvailibleCount: Int?
        var pokemons: [Pokemon] = []
        var allPokemonsLoaded: Bool {
            pokemons.count >= pokemonsAvailibleCount ?? 1
        }
    }
    
    @MainActor func addPokemons(newPokemons: [Pokemon], pokemonsAvailibleCount: Int) {
        self.userData.pokemonsAvailibleCount = pokemonsAvailibleCount
        self.userData.pokemons.append(contentsOf: newPokemons)
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.userData == rhs.userData
}
