//
//  SwiftArxivApp.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI
import SwiftData

@main
struct SwiftArxivApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Article.self,
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
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
