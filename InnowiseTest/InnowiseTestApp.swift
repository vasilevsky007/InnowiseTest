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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
