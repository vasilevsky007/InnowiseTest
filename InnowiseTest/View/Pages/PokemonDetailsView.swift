//
//  PokemonDetailsView.swift
//  InnowiseTest
//
//  Created by Alex on 20.02.24.
//

import SwiftUI

/// detailed view of the specific pokemon.
/// have 2 main sates: one when details are loaded, one when not
/// you have to trigger details load outside of this view on your own
struct PokemonDetailsView: View {
    @Environment(\.interactors) var interactors: InteractorsContainer
    
    let pokemon: Binding<Pokemon>
    @State private var image: ImageData?
    
    var body: some View {
        VStack(alignment: .center) {
            if let details = pokemon.wrappedValue.details {
                loadedPokemonBody(name: pokemon.wrappedValue.name, details: details)
                    .task {
                        loadImage()
                    }
            } else {
                loadingPokemonBody(name: pokemon.wrappedValue.name)
            }
        }
    }
    
    @ViewBuilder private func loadingPokemonBody(name: String) -> some View {
        Spacer()
        Spinner()
        Text(Strings.PokemonDetailsView.loadingPokemonText(name.localizedCapitalized))
        Spacer()
    }
    
    @ViewBuilder private func loadedPokemonBody(name: String, details: Pokemon.Details) -> some View {
        Divider()
        
        LoadableImage(image: $image) {
            loadImage()
        }
        
        Divider()
        ScrollView {
            LazyVStack(alignment: .leading) {
                Text(name.localizedCapitalized)
                    .font(.largeTitle)
                Text(Strings.PokemonDetailsView.pokemonWeightText(details.weight.kg))
                    .font(.body)
                Text(Strings.PokemonDetailsView.pokemonHeightText(details.height.cm))
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
    
    private func loadImage() {
        Task {
            guard let imageUrl = pokemon.wrappedValue.details?.sprites.front else { return }
            image = ImageData(url: imageUrl, state: .loading)
            await interactors.imageInteractor.loadImageData($image)
        }
    }
}

#Preview("loading") {
    PokemonDetailsView(pokemon: .constant(Pokemon(
        name: "bulbasaur",
        url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!,
        details: nil
    )))
}
#Preview("loaded") {
    PokemonDetailsView(pokemon: .constant(Pokemon(
        name: "bulbasaur",
        url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!,
        details: Pokemon.Details(
            height: 7,
            weight: 69,
            sprites: Pokemon.Details.Sprites(front: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")),
            types: [
                .init(slot: 1, type: .init(name: .bug)),
                .init(slot: 2, type: .init(name: .fire)),
                .init(slot: 3, type: .init(name: .ice)),
                .init(slot: 4, type: .init(name: .fighting)),
                .init(slot: 5, type: .init(name: .electric)),
            ]
        )
    )))
}
