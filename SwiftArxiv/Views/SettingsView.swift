//
//  SettingsView.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("geminiApiKey") private var geminiApiKey: String = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Gemini API Key", text: $geminiApiKey)
                    .textFieldStyle(.roundedBorder)
                
                Text("Enter your Gemini API key to enable article summarization")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("API Configuration")
            }
        }
        .padding()
        .frame(width: 400)
    }
}
