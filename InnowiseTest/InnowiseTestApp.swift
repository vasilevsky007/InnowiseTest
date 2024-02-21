//
//  InnowiseTestApp.swift
//  InnowiseTest
//
//  Created by Alex on 17.02.24.
//

import SwiftUI

@main
struct InnowiseTestApp: App {
    
    let (appState, interactorsContainer, persistenceController) = createDependencies()

    var body: some Scene {
        WindowGroup {
            PokemonListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appState)
                .environment(\.interactors, interactorsContainer)
        }
    }
    
    private static func createDependencies() -> (AppState, InteractorsContainer, PersistenceController) {
        let persistenceController = PersistenceController.shared
        let appState = AppState()
        let webRepository = RealPokemonWebRepository()
        let coreDataRepositiry = RealPokemonCoreDataRepository(context: persistenceController.container.viewContext)
        let pokemonInteractor = RealPokemonInteractor(webRepository: webRepository, coreDataRepositiry: coreDataRepositiry, appState: appState)
        let interactorsContainer = InteractorsContainer(pokemonInteractor: pokemonInteractor)
        return (appState, interactorsContainer, persistenceController)
    }
}
