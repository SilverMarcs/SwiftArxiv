//
//  ArticleRowView.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI
import SwiftData

struct ArticleRowView: View {
    let article: Article
    @Environment(\.modelContext) private var modelContext
    @Query private var savedArticles: [Article]
    
    private var isArticleSaved: Bool {
        savedArticles.contains { $0.id == article.id }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .font(.headline)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .leading) {
            if !isArticleSaved {
                Button {
                    modelContext.insert(article)
                } label: {
                    Label("Save", systemImage: "bookmark.fill")
                }
                .tint(.blue)
            }
        }
        .swipeActions(edge: .trailing) {
            if isArticleSaved {
                Button(role: .destructive) {
                    modelContext.delete(article)
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
            }
        }
    }
}
