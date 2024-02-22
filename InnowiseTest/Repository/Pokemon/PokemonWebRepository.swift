//
//  PokemonWebRepository.swift
//  InnowiseTest
//
//  Created by Alex on 18.02.24.
//

import Foundation

/// "facade" protocol for web repository  to ensure testability.
/// you can create your own struct conforming to this protocol suitable for your unit tests
protocol PokemonWebRepository {
    func loadPokemons(fromOffset: Int, limit: Int) async throws -> (pokemons:[Pokemon], availibleCount: Int) 
    func loadPokemonDetails(pokemon: Pokemon) async throws -> Pokemon.Details
}


/// real web repository, for getting pokemons. should be used inside the app
struct RealPokemonWebRepository: PokemonWebRepository {
    let session = URLSession(configuration: .ephemeral)
    
    /// func for loading given numer of pokemons from the API from the given offset
    /// - Parameters:
    ///   - offset: ofset from which to load pokemons from API
    ///   - limit: max number of pokemons to return
    /// - Returns: tuple of `Pokemon` array and overall number of pokemons availiable on server
    func loadPokemons(fromOffset offset: Int, limit: Int) async throws -> (pokemons:[Pokemon], availibleCount: Int) {
        let url = API.pokemonsRequestUrl(fromOffset: offset, limit: limit)
        let (receivedData, response) = try await session.data(from: url)
        let dataDecoded = try JSONDecoder().decode(API.PokemonsResponse.self, from: receivedData)
        return (dataDecoded.results, dataDecoded.count)
    }
    
    /// func for loading pokemon details from the API.
    /// not updating the pokemon, you have to do it on your own outside
    /// - Parameter pokemon: pass in a pokemon for loading details
    /// - Returns: `Pokemon.Details` struct with the requested data
    func loadPokemonDetails(pokemon: Pokemon) async throws -> Pokemon.Details {
        let (receivedData, response) = try await session.data(from: pokemon.url)
        let dataDecoded = try JSONDecoder().decode(Pokemon.Details.self, from: receivedData)
        return dataDecoded
    }
}
