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
        .windowStyle(.hiddenTitleBar) // Hide window title bar
        .modelContainer(sharedModelContainer)
        
        .commands {
                    // Add custom menu items
                    CommandMenu("Custom Menu") {
                        Button("Option 1", action: {
                            print("Option 1 clicked")
                        })
                        Button("Option 2", action: {
                            print("Option 2 clicked")
                        })
                    }
                }
            
    }
}
