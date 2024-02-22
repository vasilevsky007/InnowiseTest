//
//  InteractorsContainer.swift
//  InnowiseTest
//
//  Created by Alex on 18.02.24.
//

import Foundation
import SwiftUI


/// struct for storing interactors. use ``init(pokemonInteractor:)`` for real app
/// can use ``defaultValue`` for tests
struct InteractorsContainer: EnvironmentKey {
    
    let pokemonInteractor: PokemonInteractor
    
    init(pokemonInteractor: PokemonInteractor) {
        self.pokemonInteractor = pokemonInteractor
    }
    
    ///used for tests, not the actual realization
    static var defaultValue: InteractorsContainer {
        return .init(pokemonInteractor: FakePokemonInteractor())
    }
}

// for storage in @Environment
extension EnvironmentValues {
    var interactors: InteractorsContainer {
        get { self[InteractorsContainer.self] }
        set { self[InteractorsContainer.self] = newValue }
    }
}
