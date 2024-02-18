//
//  PokemonInteractor.swift
//  InnowiseTest
//
//  Created by Alex on 18.02.24.
//

import Foundation

///Interactors should be “facaded” with a protocol so that the View could talk to a mocked Interactor in tests.
protocol PokemonInteractor {
    func loadMorePokemons()
    func loadPokemon()
}

///Interactors receive requests to perform work, such as obtaining data from an external source or making computations, but they never return data back directly, such as in a closure.
///Instead, they forward the result to the AppState or a Binding provided by the View.
///The Binding is used when the result of work (the data) is owned locally by one View and does not belong to the central AppState, that is, it doesn’t need to be persisted or shared with other screens of the app.
struct RealPokemonInteractor: PokemonInteractor {
    func loadMorePokemons() {
        
    }
    
    func loadPokemon() {
        
    }
    
    
}
