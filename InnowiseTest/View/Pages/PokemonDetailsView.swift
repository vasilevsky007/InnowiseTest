//
//  PokemonDetailsView.swift
//  InnowiseTest
//
//  Created by Alex on 20.02.24.
//

import SwiftUI

struct PokemonDetailsView: View {
    let pokemon: Binding<Pokemon>
    var body: some View {
        VStack(alignment: .center) {
            if let details = pokemon.wrappedValue.details {
                loadedPokemonBody(name: pokemon.wrappedValue.name, details: details)
            } else {
                loadingPokemonBody(name: pokemon.wrappedValue.name)
            }
        }
    }
    
    @ViewBuilder private func loadingPokemonBody(name: String) -> some View {
        Spacer()
        Spinner()
        Text("Loading pokemon '\(name.localizedCapitalized)' info...")
        Spacer()
    }
    
    @ViewBuilder private func loadedPokemonBody(name: String, details: Pokemon.Details) -> some View {
        Divider()
        
        AsyncImage(url: details.sprites.front) { image in
            image
                .resizable(resizingMode: .stretch)
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Spacer()
            Spinner()
                .aspectRatio(contentMode: .fit)
            Spacer()
        }
        
        Divider()
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text(name.localizedCapitalized)
                    .font(.largeTitle)
                Text("Pokemon weight: \(details.weight.kg) kg")
                    .font(.body)
                Text("Pokemon height: \(details.height.cm) cm")
                    .font(.body)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(details.types, id: \.self.slot) { type in
                        PokemonTypeBadge(type: type.type.name)
                    }
                }
            }
        }
        Spacer()
    }
}

//#Preview("loading") {
//    PokemonDetailsView(pokemon: Pokemon(
//        name: "bulbasaur",
//        url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!,
//        details: nil
//    ))
//}
//#Preview("loaded") {
//    PokemonDetailsView(pokemon: Pokemon(
//        name: "bulbasaur",
//        url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!,
//        details: Pokemon.Details(
//            height: 7,
//            weight: 69,
//            sprites: Pokemon.Details.Sprites(front: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")),
//            types: [
//                .init(slot: 1, type: .init(name: .bug)),
//                .init(slot: 2, type: .init(name: .fire)),
//                .init(slot: 3, type: .init(name: .ice)),
//                .init(slot: 4, type: .init(name: .fighting)),
//                .init(slot: 5, type: .init(name: .electric)),
//            ]
//        )
//    ))
//}
