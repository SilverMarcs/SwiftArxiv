//
//  ArticleRowView.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title)
                .font(.headline)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}
