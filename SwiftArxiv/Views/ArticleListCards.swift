//
//  ArticleListCards.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI
import SwiftData

enum ArticleListMode {
    case search
    case saved
}

struct ArticleListCards: View {
    @Binding var mode: ArticleListMode
    @Query private var savedArticles: [Article]
    
    private var spacing: CGFloat {
        #if os(macOS)
        return 8
        #else
        return 13
        #endif
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ListCard(
                icon: "magnifyingglass.circle.fill",
                iconColor: .blue,
                title: "Search",
                count: mode == .search ? "" : "") {
                    mode = .search
                }
            
            ListCard(
                icon: "bookmark.circle.fill",
                iconColor: .indigo,
                title: "Saved",
                count: "\(savedArticles.count)") {
                    mode = .saved
                }
        }
        .padding(.horizontal, -5)
        .padding(.vertical, 4)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
//        .listRowInsets(EdgeInsets(top: 8, leading: -5, bottom: -5, trailing: 0))
    }
}

#Preview {
    ArticleListCards(mode: .constant(.search))
        .modelContainer(for: Article.self, inMemory: true)
}
