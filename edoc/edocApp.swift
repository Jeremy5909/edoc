//
//  edocApp.swift
//  edoc
//
//  Created by Jeremy Eiser-Herczeg on 3/19/24.
//

import SwiftUI
import SwiftData

@main
struct edocApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
