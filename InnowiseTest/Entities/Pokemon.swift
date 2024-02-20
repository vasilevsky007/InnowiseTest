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
    var details: Details?
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
            let front: URL?
            
            enum CodingKeys: String, CodingKey {
                case front = "front_default"
            }
        }
        
        ///types of the pokemon
        struct PokemonType: Equatable, Codable {
            /// wrapper on ``Types``
            struct Typee: Equatable, Codable {
                let name: Types
            }
            let slot: Int
            let type: Typee
        }
        
        let height: PokemonHeight
        let weight: PokemonWeight
        let sprites: Sprites
        let types: [PokemonType]
    }
}

extension Pokemon.Details {
    typealias PokemonWeight = Int
    typealias PokemonHeight = Int
}

extension Pokemon.Details.PokemonWeight {
    //regretfully, this will be showing on any int...
    var kg: String {
        "\((Double(self) / 10))"
    }
}
extension Pokemon.Details.PokemonHeight {
    //regretfully, this will be showing on any int...
    var cm: String {
        "\(self * 10)"
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
        //i guess it's Stellar, some translate issues??? look https://bulbapedia.bulbagarden.net/wiki/Type for reference
        case shadow
        case unknown
    }
}
