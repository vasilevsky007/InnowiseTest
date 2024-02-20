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
    
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
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
            Text("Select a pokemon")
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

#Preview {
    let (appState, interactorsContainer) = InnowiseTestApp.createDependencies()
    return PokemonListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(appState)
        .environment(\.interactors, interactorsContainer)
}
