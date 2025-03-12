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
    @State private var mode: ArticleListMode = .search
    @Query private var savedArticles: [Article]
    
    var body: some View {
        NavigationSplitView {
            List(selection: $model.selectedArticle) {
                ArticleListCards(mode: $mode)
                
                if mode == .search {
                    if model.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .controlSize(.large)
                                .padding()
                            Spacer()
                        }
                    } else {
                        ForEach(model.articles, id: \.self) { article in
                            ArticleRowView(article: article)
                        }
                    }
                } else {
                    ForEach(savedArticles, id: \.self) { article in
                        ArticleRowView(article: article)
                    }
                }
            }
            .navigationTitle(mode == .search ? "Search" : "Saved")
            
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
            Task {
                await model.searchArticles()
            }
        }
        .alert("Error", isPresented: .init(
                get: { model.errorMessage != nil},
                set: { if !$0 { model.errorMessage = nil } }
            )
        ) {
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
