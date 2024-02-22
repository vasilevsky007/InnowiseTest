//
//  Strings.swift
//  InnowiseTest
//
//  Created by Alex on 22.02.24.
//

import Foundation

/// struct to remove "magical" strings from sources
struct Strings {
    struct PokemonListView {
        static let navigationTitle = "Pokemons"
        static let noSelectionText = "Select a pokemon"
        static let loadingText = "Loading..."
    }
    
    struct PokemonDetailsView {
        static func loadingPokemonText(_ name: String) -> String {
            "Loading pokemon '\(name)' info..."
        }
        static func pokemonWeightText(_ weight: String) -> String {
            "Pokemon weight: \(weight) kg"
        }
        static func pokemonHeightText(_ weight: String) -> String {
            "Pokemon height: \(weight) cm"
        }
    }
    
    struct SettingsView {
        static let navigationTitle = "Settings"
        static let clearCacheText = "Clear cache"
        static let cacheSizeText = "Cache size"
        static let noCacheSizeText = "Unable to load cache size"
    }
    
    struct Sources {
        static let settingsIcon = "gear"
        
        static let colorPath = "Colors/"
        static let imagePath = "Images/"
        
        static let persistentContainerName = "InnowiseTest"
    }
}