//
//  ContentView.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        #if os(iOS)
        iOSContentView()
        #else
        macOSContentView()
        #endif
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Article.self, inMemory: true)
}
