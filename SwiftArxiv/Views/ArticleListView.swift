//
//  ArticleListView.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI
import SwiftData

struct ArticleListView: View {
    @Binding var mode: ArticleListMode
    @Binding var selectedArticle: Article?
    let searchedArticles: [Article]
    let isLoading: Bool
    @Query private var savedArticles: [Article]
    
    var body: some View {
        List(selection: $selectedArticle) {
            ArticleListCards(mode: $mode)
            
            if mode == .search {
                if isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .controlSize(.large)
                            .padding()
                        Spacer()
                    }
                } else if searchedArticles.isEmpty {
                    ContentUnavailableView {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                } else {
                    ForEach(searchedArticles, id: \.self) { article in
                        ArticleRowView(article: article)
                    }
                }
            } else {
                if savedArticles.isEmpty {
                    ContentUnavailableView {
                        Label("No Saved Articles", systemImage: "bookmark")
                    } description: {
                        Text("Your saved articles will appear here")
                    }
                } else {
                    ForEach(savedArticles, id: \.self) { article in
                        ArticleRowView(article: article)
                    }
                }
            }
        }
        .navigationTitle(mode == .search ? "Search" : "Saved")
    }
}

#Preview {
    ArticleListView(
        mode: .constant(.search),
        selectedArticle: .constant(nil),
        searchedArticles: [],
        isLoading: false
    )
    .modelContainer(for: Article.self, inMemory: true)
}
