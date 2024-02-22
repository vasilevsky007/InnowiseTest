//
//  SettingsView.swift
//  InnowiseTest
//
//  Created by Alex on 22.02.24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.interactors) var interactors: InteractorsContainer
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Strings.SettingsView.cacheSizeText)
                .font(.title2)
            Text(appState.userData.cacheSize?.formattedFileSize ?? Strings.SettingsView.noCacheSizeText)
            Button(role: .destructive) {
                interactors.pokemonInteractor.clearCache()
            } label: {
                Text(Strings.SettingsView.clearCacheText)
            }.buttonStyle(.borderedProminent)
            Divider()
            Spacer().frame(maxWidth: .infinity)
        }
        .padding(DrawingConstants.standardSpacing)
        .navigationTitle(Strings.SettingsView.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let appState = AppState()
    let webRepository = RealPokemonWebRepository()
    let coreDataRepositiry = FakePokemonCoreDataRepository()
    let pokemonInteractor = RealPokemonInteractor(webRepository: webRepository, coreDataRepositiry: coreDataRepositiry, appState: appState)
    let interactorsContainer = InteractorsContainer(pokemonInteractor: pokemonInteractor)
    return SettingsView()
        .environmentObject(appState)
        .environment(\.interactors, interactorsContainer)
}
