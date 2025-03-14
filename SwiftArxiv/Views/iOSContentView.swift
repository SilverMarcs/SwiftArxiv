//
//  iOSContentView.swift
//  SwiftArxiv
//
//  Created by Assistant on 14/03/2025.
//

import SwiftUI
import SwiftData

struct iOSContentView: View {
    @State private var model = ArxivSearchModel()
    @State private var mode: ArticleListMode = .saved
    @State private var selectedTab: ArticleListMode = .saved
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ArticleListView(
                    mode: .constant(.search),
                    selectedArticle: $model.selectedArticle,
                    searchedArticles: model.articles,
                    isLoading: model.isLoading
                )
                .navigationDestination(item: $model.selectedArticle) { article in
                    ArticleDetailView(article: article)
                }
            }
            .searchable(text: $model.searchQuery, prompt: "Search arXiv papers")
            .onSubmit(of: .search) {
                Task {
                    await model.searchArticles()
                }
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(ArticleListMode.search)
            
            NavigationStack {
                ArticleListView(
                    mode: .constant(.saved),
                    selectedArticle: $model.selectedArticle,
                    searchedArticles: model.articles,
                    isLoading: model.isLoading
                )
                .navigationDestination(item: $model.selectedArticle) { article in
                    ArticleDetailView(article: article)
                }
            }
            .tabItem {
                Label("Saved", systemImage: "bookmark")
            }
            .tag(ArticleListMode.saved)
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
    iOSContentView()
        .modelContainer(for: Article.self, inMemory: true)
}
