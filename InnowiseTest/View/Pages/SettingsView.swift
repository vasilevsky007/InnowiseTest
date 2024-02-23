//
//  SettingsView.swift
//  InnowiseTest
//
//  Created by Alex on 22.02.24.
//

import SwiftUI

/// settings view of the app. now used for displaying cache parameters
struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.interactors) var interactors: InteractorsContainer
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(Strings.SettingsView.cacheSizeText)
                    .font(.title2)
                Text(appState.userData.cacheSize?.formattedFileSize ?? Strings.SettingsView.noCacheSizeText)
                Button(role: .destructive) {
                    interactors.pokemonInteractor.clearCache()
                } label: {
                    Text(Strings.SettingsView.clearCacheText)
                }.buttonStyle(.borderedProminent)
                Text(Strings.SettingsView.clearCacheDisclaimer)
                    .foregroundStyle(.secondary)
                    .font(.caption2)
                Divider()
                Text(Strings.SettingsView.imageCacheSizeText)
                    .font(.title2)
                Text(appState.userData.imageCacheSize?.formattedFileSize ?? Strings.SettingsView.noCacheSizeText)
                Button(role: .destructive) {
                    interactors.imageInteractor.clearImageCache()
                } label: {
                    Text(Strings.SettingsView.clearCacheText)
                }.buttonStyle(.borderedProminent)
                Divider()
                Spacer().frame(maxWidth: .infinity)
            }
            .padding(DrawingConstants.standardSpacing)
        }
        .navigationTitle(Strings.SettingsView.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
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
    
    return SettingsView()
        .environmentObject(appState)
        .environment(\.interactors, interactorsContainer)
}
