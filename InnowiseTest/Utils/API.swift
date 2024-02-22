//
//  API.swift
//  InnowiseTest
//
//  Created by Alex on 18.02.24.
//

import Foundation

/// struct containing API specific info
struct API {
    /// endpoint `URLComponents` for pokemon list load
    static let pokemonEndpoint = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pokeapi.co"
        urlComponents.path = "/api/v2/pokemon/"
        return urlComponents
    }()
    
    /// struct for decoding pokemon list responce from the API
    struct PokemonsResponse: Codable {
        let count: Int
        let results: [Pokemon]
    }
}
