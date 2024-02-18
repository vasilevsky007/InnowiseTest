//
//  PokemonWebRepository.swift
//  InnowiseTest
//
//  Created by Alex on 18.02.24.
//

import Foundation

protocol PokemonWebRepository {
    func loadPokemons(fromOffset: Int, limit: Int)
    func loadPokemonDetails(pokemon: Pokemon)
}

struct RealPokemonWebRepository: PokemonWebRepository {
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func loadPokemons(fromOffset: Int, limit: Int) {
        
    }
    
    func loadPokemonDetails(pokemon: Pokemon) {
        
    }
}
