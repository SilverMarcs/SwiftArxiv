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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .font(.headline)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing) {
            Button {
                modelContext.insert(article)
            } label: {
                Label("Save", systemImage: "bookmark.fill")
            }
            .tint(.blue)
        }
    }
}
