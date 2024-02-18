//
//  Pokemon.swift
//  InnowiseTest
//
//  Created by Alex on 18.02.24.
//

import Foundation

///basic pokemon struct, used to represent it on list
struct Pokemon: Equatable, Codable {
    let name: String
    let url: URL
    let details: Details?
}

extension Pokemon: Identifiable {
    var id: URL {
        self.url
    }
}

extension Pokemon {
    ///details struct, used for additional information on pokemon details page.
    struct Details: Equatable, Codable {
        struct Sprites: Equatable, Codable {
            let front: URL
        }
        
        /// wrapper on ``Types``
        struct PokemonType: Equatable, Codable {
            let name: Types
        }
        
        let height: Int
        let weight: Int
        let sprites: Sprites
        let types: [PokemonType]
    }
}

extension Pokemon.Details {
    ///types of the pokemon
    enum Types: String, Codable {
        case normal
        case fighting
        case flying
        case poison
        case ground
        case rock
        case bug
        case ghost
        case steel
        case fire
        case water
        case grass
        case electric
        case psychic
        case ice
        case dragon
        case dark
        case fairy
        case shadow
        case unknown
    }
}
