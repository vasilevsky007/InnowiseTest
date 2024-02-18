//
//  AppState.swift
//  InnowiseTest
//
//  Created by Alex on 17.02.24.
//

import Foundation

///AppState works as the single source of truth and keeps the state for the entire app, including user’s data, authentication tokens, screen navigation state (selected tabs, presented sheets) and system state (is active / is backgrounded, etc.)
class AppState: ObservableObject, Equatable {
    @Published var userData = UserData()
    @Published var routing = ViewRouting()
    @Published var system = System()
}

extension AppState {
    struct UserData: Equatable {
        //some data accessible to all views. single
        var pokemons: [Pokemon] = []
    }
}

extension AppState {
    struct ViewRouting: Equatable {
    }
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.userData == rhs.userData &&
    lhs.routing == rhs.routing &&
    lhs.system == rhs.system
}
