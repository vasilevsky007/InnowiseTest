//
//  InnowiseTestApp.swift
//  InnowiseTest
//
//  Created by Alex on 17.02.24.
//

import SwiftUI

@main
struct InnowiseTestApp: App {
    
    let (appState, interactorsContainer) = createDependencies()

    var body: some Scene {
        WindowGroup {
            PokemonListView()
                .environmentObject(appState)
                .environment(\.interactors, interactorsContainer)
        }
    }
    
    /// func preparing all needed dependenies for app running
    /// - Returns: tuple of appstate, the single source of truth for our app, and interactors container.
    private static func createDependencies() -> (AppState, InteractorsContainer) {
        let persistenceController = PersistenceController.shared
        let appState = AppState()
        let webRepository = RealPokemonWebRepository()
        let coreDataRepositiry = RealPokemonCoreDataRepository(context: persistenceController.container.viewContext)
        let pokemonInteractor = RealPokemonInteractor(webRepository: webRepository, coreDataRepositiry: coreDataRepositiry, appState: appState)
        
        let imageWebRepository = RealImageWebRepository()
        let imageCoreDataRepositiry = RealImageCoreDataRepository(context: persistenceController.container.viewContext)
        let imageInteractor = RealImageInteractor(webRepository: imageWebRepository, coreDataRepositiry: imageCoreDataRepositiry, appState: appState)
        
        let interactorsContainer = InteractorsContainer(pokemonInteractor: pokemonInteractor, imageInteractor: imageInteractor)
        return (appState, interactorsContainer)
    }
}
