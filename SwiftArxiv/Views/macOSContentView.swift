//
//  macOSContentView.swift
//  SwiftArxiv
//
//  Created by Assistant on 14/03/2025.
//

import SwiftUI
import SwiftData

struct macOSContentView: View {
    @State private var model = ArxivSearchModel()
    @State private var mode: ArticleListMode = .saved
    
    var body: some View {
        NavigationSplitView {
            ArticleListView(
                mode: $mode,
                selectedArticle: $model.selectedArticle,
                searchedArticles: model.articles,
                isLoading: model.isLoading
            )
        } detail: {
            if let selectedArticle = model.selectedArticle {
                ArticleDetailView(article: selectedArticle)
            } else {
                ContentUnavailableView {
                    Label("No Selection", systemImage: "doc.text")
                } description: {
                    Text("Select an article to view details")
                }
                .toolbarBackground(.hidden)
            }
        }
        .background(.background)
        .searchable(text: $model.searchQuery, placement: .sidebar, prompt: "Search arXiv papers")
        .onSubmit(of: .search) {
            mode = .search
            Task {
                await model.searchArticles()
            }
        }
        .alert("Error", isPresented: .init(
            get: { model.errorMessage != nil},
            set: { if !$0 { model.errorMessage = nil } }
        )) {
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
    macOSContentView()
        .modelContainer(for: Article.self, inMemory: true)
}
