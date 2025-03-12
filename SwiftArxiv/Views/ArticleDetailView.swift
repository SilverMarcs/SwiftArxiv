//
//  ArticleDetailView.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    @State private var invertColors = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title and Actions
                    Group {
                        Text(article.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Action buttons
                        HStack(spacing: 12) {
                            if let pdfUrl = article.pdfUrl {
                                NavigationLink {
                                    PDFKitView(url: pdfUrl)
                                        .if(invertColors) {
                                            $0.colorInvert()
                                        }
                                        .toolbar {
                                            ToolbarItem {
                                                Button {
                                                    invertColors.toggle()
                                                } label: {
                                                    Image(systemName: (invertColors ? "sun.min.fill" : "moon.fill"))
                                                }
                                            }
                                        }
                                        .navigationTitle("PDF Preview")
                                        .toolbarTitleDisplayMode(.inline)
                                } label: {
                                    Label("PDF", systemImage: "doc.text.fill")
                                }
                                .buttonStyle(.bordered)
                            }
                            
                            if let htmlUrl = article.htmlUrl {
                                Link(destination: htmlUrl) {
                                    Label("Web", systemImage: "safari.fill")
                                }
                                .buttonStyle(.bordered)
                            }
                            
                            if let doiUrl = article.doiUrl {
                                Link(destination: doiUrl) {
                                    Label("DOI", systemImage: "link")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Abstract
                    if let abstract = article.abstract {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Abstract", systemImage: "text.justify")
                                .font(.headline)
                            Text(abstract)
                                .font(.body)
                        }
                        Divider()
                    }
                    
                    // Authors
                    if !article.authors.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Authors", systemImage: "person.2")
                                .font(.headline)
                            Text(article.authors.joined(separator: ", "))
                                .font(.body)
                        }
                        Divider()
                    }
                    
                    // Dates
                    Group {
                        if let published = article.published {
                            HStack {
                                Label("Published", systemImage: "calendar")
                                    .font(.subheadline)
                                Spacer()
                                Text(dateFormatter.string(from: published))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        if let updated = article.updated, updated != article.published {
                            HStack {
                                Label("Updated", systemImage: "calendar.badge.clock")
                                    .font(.subheadline)
                                Spacer()
                                Text(dateFormatter.string(from: updated))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    // Categories
                    if !article.categories.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Categories", systemImage: "tag")
                                .font(.headline)
                            
                            //                        FlowLayout(spacing: 8) {
                            HStack {
                                ForEach(article.categories, id: \.self) { category in
                                    Text(category)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.secondary.opacity(0.2))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        Divider()
                    }
                    
                    // Additional Information
                    Group {
                        if let journalRef = article.journalRef {
                            HStack {
                                Label("Journal Ref", systemImage: "newspaper")
                                    .font(.subheadline)
                                Spacer()
                                Text(journalRef)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        if let comment = article.comment {
                            HStack {
                                Label("Comment", systemImage: "text.quote")
                                    .font(.subheadline)
                                Spacer()
                                Text(comment)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(.background)
        .scrollContentBackground(.visible)
    }
}

extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> TupleView<(Self?, Content?)> {
        if conditional {
            return TupleView((nil, content(self)))
        } else {
            return TupleView((self, nil))
        }
    }
}
