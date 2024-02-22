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
    let imageInteractor: ImageInteractor
    
    init(pokemonInteractor: PokemonInteractor, imageInteractor: ImageInteractor) {
        self.pokemonInteractor = pokemonInteractor
        self.imageInteractor = imageInteractor
    }
    
    ///used for tests, not the actual realization
    static var defaultValue: InteractorsContainer {
        return .init(pokemonInteractor: FakePokemonInteractor(), imageInteractor: FakeImageInteractor())
    }
}

// for storage in @Environment
extension EnvironmentValues {
    var interactors: InteractorsContainer {
        get { self[InteractorsContainer.self] }
        set { self[InteractorsContainer.self] = newValue }
    }
}
