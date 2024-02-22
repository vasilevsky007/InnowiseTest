//
//  PokemonListView.swift
//  InnowiseTest
//
//  Created by Alex on 17.02.24.
//

import SwiftUI
import CoreData

///  main view of the app, displaying the list of the pokemos
struct PokemonListView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.interactors) var interactors: InteractorsContainer
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach($appState.userData.pokemons) { pokemon in
                        NavigationLink {
                            PokemonDetailsView(pokemon: pokemon)
                                .navigationTitle(pokemon.wrappedValue.name.localizedCapitalized)
                                .navigationBarTitleDisplayMode(.inline)
                                .task {
                                    try? await interactors.pokemonInteractor.loadPokemonDetails(pokemon: pokemon.wrappedValue)
                                }
                        } label: {
                            Text(pokemon.wrappedValue.name.localizedCapitalized)
                        }
                    }
                    if(!appState.userData.allPokemonsLoaded) {
                        HStack(alignment: .center){
                            Text(Strings.PokemonListView.loadingText)
                            //FIXME: is showing spinner only on initial load.
                            ProgressView()
                            Spacer()
                        }.task {
                            try? await interactors.pokemonInteractor.loadMorePokemons()
                        }
                    }
                }
            }
            .navigationTitle(Strings.PokemonListView.navigationTitle)
            .toolbar {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: Strings.Sources.settingsIcon)
                        .font(.title2)
                        .padding(DrawingConstants.smallSpacing)
                }
            }
            Text(Strings.PokemonListView.noSelectionText)
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
