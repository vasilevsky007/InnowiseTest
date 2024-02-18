//
//  InteractorsContainer.swift
//  InnowiseTest
//
//  Created by Alex on 18.02.24.
//

import Foundation

import SwiftUI

struct InteractorsContainer: EnvironmentKey {
    
    let pokemonInteractor: PokemonInteractor
    
    init(pokemonInteractor: PokemonInteractor) {
        self.pokemonInteractor = pokemonInteractor
    }
    
    static var defaultValue: InteractorsContainer {
        return .init(pokemonInteractor: FakePokemonInteractor())
    }
}

extension EnvironmentValues {
    var interactors: InteractorsContainer {
        get { self[InteractorsContainer.self] }
        set { self[InteractorsContainer.self] = newValue }
    }
}
