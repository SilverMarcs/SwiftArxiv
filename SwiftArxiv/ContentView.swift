//
//  ContentView.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var model = ArxivSearchModel()
    
    var body: some View {
        NavigationSplitView {
            List(model.articles, id: \.self, selection: $model.selectedArticle) { article in
                ArticleRowView(article: article)
            }
            .padding(.top, 5)
            .navigationTitle("arXiv Search")
        } detail: {
            if let selectedArticle = model.selectedArticle {
                ArticleDetailView(article: selectedArticle)
            } else {
                ContentUnavailableView {
                    Label("No Selection", systemImage: "doc.text")
                } description: {
                    Text("Select an article to view details")
                }
            }
        }
        .searchable(text: $model.searchQuery, placement: .sidebar, prompt: "Search arXiv papers")
        .onSubmit(of: .search) {
            Task {
                await model.searchArticles()
            }
        }
        .alert("Error", isPresented: .init(get: { model.errorMessage != nil }, set: { if !$0 { model.errorMessage = nil } })) {
            Button("OK") {
                model.errorMessage = nil
            }
        } message: {
            if let errorMessage = model.errorMessage {
                Text(errorMessage)
            }
        }
    }
}


#Preview {
    ContentView()
}
