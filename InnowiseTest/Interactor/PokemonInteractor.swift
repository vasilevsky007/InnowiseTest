//
//  PokemonInteractor.swift
//  InnowiseTest
//
//  Created by Alex on 18.02.24.
//

import Foundation
import Combine

///Interactors should be “facaded” with a protocol so that the View could talk to a mocked Interactor in tests.
protocol PokemonInteractor {
    func loadMorePokemons() async throws
    func loadPokemonDetails(pokemon: Pokemon) async throws
    func clearCache()
}

///Interactors receive requests to perform work, such as obtaining data from an external source or making computations, but they never return data back directly, such as in a closure.
///Instead, they forward the result to the AppState or a Binding provided by the View.
///The Binding is used when the result of work (the data) is owned locally by one View and does not belong to the central AppState, that is, it doesn’t need to be persisted or shared with other screens of the app.
struct RealPokemonInteractor: PokemonInteractor {
    private let step = 30
    private var availibleCount: Int?
    private var webRepository: PokemonWebRepository
    private var coreDataRepositiry: PokemonCoreDataRepository
    private var appState: AppState
    
    private var cancellables = Set<AnyCancellable>()
    
    init(webRepository: PokemonWebRepository, coreDataRepositiry: PokemonCoreDataRepository, appState: AppState) {
        self.webRepository = webRepository
        self.coreDataRepositiry = coreDataRepositiry
        self.appState = appState
        
        coreDataRepositiry.coreDataSize
            .sink { fileSize in
                Task{
                    await appState.changeCacheSize(fileSize)
                }
            }
            .store(in: &cancellables)
    }
    
    /// func for loading pokemons either from APi or from persistant storage.
    ///  automatically saves data to `AppState` and persistant storage if needed
    func loadMorePokemons() async throws {
        if (!appState.userData.allPokemonsLoaded) {
            do {
                let (newPokemons, availibleCount) = try await webRepository.loadPokemons(fromOffset: appState.userData.pokemons.count, limit: step)
                Task {
                    await appState.addPokemons(newPokemons: newPokemons, pokemonsAvailibleCount: availibleCount)
                }
                try? coreDataRepositiry.savePokemons(newPokemons, fromOffset: appState.userData.pokemons.count, availibleCount: availibleCount)
            } catch {
                let (newPokemons, availibleCount) = try coreDataRepositiry.loadPokemons(fromOffset: appState.userData.pokemons.count, limit: step)
                Task {
                    await appState.addPokemons(newPokemons: newPokemons, pokemonsAvailibleCount: availibleCount)
                }
            }
        }
    }
    
    /// func for loading pokemon detailed info from APi
    /// automatically saves data to persistant storage and `AppState`
    /// - Parameter pokemon: pokemon to load details
    func loadPokemonDetails(pokemon: Pokemon) async throws {
        if pokemon.details == nil {
            let details = try await webRepository.loadPokemonDetails(pokemon: pokemon)
            Task {
                await appState.addDetails(details, to: pokemon)
            }
            try coreDataRepositiry.updatePokemon(pokemon, updatedDetails: details)
        }
    }
    
    /// clears persistant storage
    func clearCache() {
        do {
            try coreDataRepositiry.clearStorage()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct FakePokemonInteractor: PokemonInteractor {
    func loadMorePokemons() async throws {
    }
    
    func loadPokemonDetails(pokemon: Pokemon) async throws {
    }
    func clearCache(){
    }
}
