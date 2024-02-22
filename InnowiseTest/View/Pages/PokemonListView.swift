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
    
    @State private var isShowingAlert = false
    @State private var errorNeedsReload = false
    @State private var errorShowing: Error?
    
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
                                    do {
                                        try await interactors.pokemonInteractor.loadPokemonDetails(pokemon: pokemon.wrappedValue)
                                    } catch {
                                        errorShowing = error
                                        errorNeedsReload = false
                                        isShowingAlert = true
                                    }
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
                            do {
                                try await interactors.pokemonInteractor.loadMorePokemons()
                            } catch {
                                errorShowing = error
                                errorNeedsReload = true
                                isShowingAlert = true
                            }
                        }
                    }
                }
                .refreshable {
                    interactors.pokemonInteractor.clearCurrentPokemons()
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
        .alert(Strings.ErrorAlert.title, isPresented: $isShowingAlert) {
            Button(Strings.ErrorAlert.ok, role: .cancel) {
                isShowingAlert = false
            }
            if (errorNeedsReload) {
                Button(Strings.ErrorAlert.reload) {
                    isShowingAlert = false
                    Task {
                        do {
                            try await interactors.pokemonInteractor.loadMorePokemons()
                        } catch {
                            errorShowing = error
                            errorNeedsReload = true
                            isShowingAlert = true
                        }
                    }
                }
            }
        } message: {
            Text(errorShowing?.localizedDescription ?? "")
        }
        
    }
}

#Preview {
    let appState = AppState()
    let webRepository = RealPokemonWebRepository()
    let coreDataRepositiry = FakePokemonCoreDataRepository()
    let pokemonInteractor = RealPokemonInteractor(webRepository: webRepository, coreDataRepositiry: coreDataRepositiry, appState: appState)
    
    let imageWebRepository = RealImageWebRepository()
    let imageCoreDataRepositiry = FakeImageCoreDataRepository()
    let imageInteractor = RealImageInteractor(webRepository: imageWebRepository, coreDataRepositiry: imageCoreDataRepositiry, appState: appState)
    
    let interactorsContainer = InteractorsContainer(pokemonInteractor: pokemonInteractor, imageInteractor: imageInteractor)
    
    return PokemonListView()
        .environmentObject(appState)
        .environment(\.interactors, interactorsContainer)
}
