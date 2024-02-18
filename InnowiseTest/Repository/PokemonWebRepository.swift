//
//  PokemonWebRepository.swift
//  InnowiseTest
//
//  Created by Alex on 18.02.24.
//

import Foundation

protocol PokemonWebRepository {
    func loadPokemons(fromOffset: Int, limit: Int) async throws -> (pokemons:[Pokemon], availibleCount: Int) 
    func loadPokemonDetails(pokemon: Pokemon)
}

struct RealPokemonWebRepository: PokemonWebRepository {
    let session = URLSession(configuration: .ephemeral)
    let baseURLComponents = API.pokemonEndpoint
    
    func loadPokemons(fromOffset offset: Int, limit: Int) async throws -> (pokemons:[Pokemon], availibleCount: Int) {
        let queryItems = [
            URLQueryItem(name: "limit", value: limit.formatted(.number)),
            URLQueryItem(name: "offset", value: offset.formatted(.number))
        ]
        var urlComponents = baseURLComponents
        urlComponents.queryItems = queryItems
        let (receivedData, response) = try await session.data(from: urlComponents.url!)
        let dataDecoded = try JSONDecoder().decode(API.PokemonsResponse.self, from: receivedData)
        return (dataDecoded.results, dataDecoded.count)
    }
    
    func loadPokemonDetails(pokemon: Pokemon) {
        
    }
}
