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
    
    /// func for building url to request pokemons from the API
    /// - Parameters:
    ///   - offset: offset from which to request pokemons
    ///   - limit: max number of requested items
    /// - Returns: URL for the API request
    static func pokemonsRequestUrl(fromOffset offset: Int, limit: Int) -> URL {
        var urlComponents = pokemonEndpoint
        let queryItems = [
            URLQueryItem(name: "limit", value: limit.formatted(.number)),
            URLQueryItem(name: "offset", value: offset.formatted(.number))
        ]
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
    
    /// struct for decoding pokemon list responce from the API
    struct PokemonsResponse: Codable {
        let count: Int
        let results: [Pokemon]
    }
}

extension Pokemon.Details.Sprites {
    enum CodingKeys: String, CodingKey {
        case front = "front_default"
    }
}
