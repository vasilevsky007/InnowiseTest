//
//  InnowiseTestApp.swift
//  InnowiseTest
//
//  Created by Alex on 17.02.24.
//

import SwiftUI

@main
struct InnowiseTestApp: App {
    let persistenceController = PersistenceController.shared
    let (appState, interactorsContainer) = createDependencies()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appState)
                .environment(\.interactors, interactorsContainer)
        }
    }
    
    static func createDependencies() -> (AppState, InteractorsContainer) {
        let appState = AppState()
        let webRepository = RealPokemonWebRepository()
        let pokemonInteractor = RealPokemonInteractor(webRepository: webRepository, appState: appState)
        let interactorsContainer = InteractorsContainer(pokemonInteractor: pokemonInteractor)
        return (appState, interactorsContainer)
    }
}
