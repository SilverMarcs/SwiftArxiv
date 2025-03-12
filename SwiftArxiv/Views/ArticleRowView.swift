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
    
    private var categoryIcon: ArticleCategory {
        if let primaryCategory = article.primaryCategory {
            return ArticleCategory(from: primaryCategory)
        }
        return .other
    }
    
    var body: some View {
        Label {
            Text(article.title)
                .font(.body)
                .lineLimit(2)
        } icon: {
            Image(systemName: categoryIcon.iconName)
                .foregroundStyle(categoryIcon.color)
                
        }
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
