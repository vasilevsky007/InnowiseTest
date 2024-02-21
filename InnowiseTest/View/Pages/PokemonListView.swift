//
//  PokemonListView.swift
//  InnowiseTest
//
//  Created by Alex on 17.02.24.
//

import SwiftUI
import CoreData

struct PokemonListView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.interactors) var interactors: InteractorsContainer

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    VStack {
                        Text("Cache size")
                        Text(appState.userData.cacheSize?.formattedFileSize ?? "")
                        Button("Clear cache") {
                            interactors.pokemonInteractor.clearCache()
                        }
                        Spacer()
                    }
                } label: {
                    Image(systemName: "gear")
                }
                List {
                    ForEach($appState.userData.pokemons) { pokemon in
                        NavigationLink {
                            PokemonDetailsView(pokemon: pokemon)
                                .task {
                                    try? await interactors.pokemonInteractor.loadPokemonDetails(pokemon: pokemon.wrappedValue)
                                }
                        } label: {
                            Text(pokemon.wrappedValue.name.localizedCapitalized)
                        }
                    }
                    if(!appState.userData.allPokemonsLoaded) {
                        HStack(alignment: .center){
                            Text("Loading...")
                            //FIXME: is showing spinner only on initial load.
                            ProgressView()
                            Spacer()
                        }.task {
                            try? await interactors.pokemonInteractor.loadMorePokemons()
                        }
                    }
                }
            }
            Text("Select a pokemon")
        }
    }
}

#Preview {
    let appState = AppState()
    let webRepository = RealPokemonWebRepository()
    let coreDataRepositiry = FakePokemonCoreDataRepository()
    let pokemonInteractor = RealPokemonInteractor(webRepository: webRepository, coreDataRepositiry: coreDataRepositiry, appState: appState)
    let interactorsContainer = InteractorsContainer(pokemonInteractor: pokemonInteractor)
    return PokemonListView()
        .environmentObject(appState)
        .environment(\.interactors, interactorsContainer)
}
