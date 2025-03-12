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
    
    var body: some View {
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
                            Link(destination: pdfUrl) {
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
                        
                        FlowLayout(spacing: 8) {
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
}

// Helper view for wrapping category tags
struct FlowLayout: Layout {
    var spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height = rows.map { $0.height }.reduce(0, +) + spacing * CGFloat(rows.count - 1)
        return CGSize(width: proposal.width ?? 0, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        
        for row in rows {
            var x = bounds.minX
            for view in row.views {
                let size = view.sizeThatFits(proposal)
                view.place(at: CGPoint(x: x, y: y), proposal: proposal)
                x += size.width + spacing
            }
            y += row.height + spacing
        }
    }
    
    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var currentRow = Row()
        var x: CGFloat = 0
        
        for view in subviews {
            let size = view.sizeThatFits(proposal)
            
            if x + size.width > (proposal.width ?? 0) && !currentRow.views.isEmpty {
                rows.append(currentRow)
                currentRow = Row()
                x = 0
            }
            
            currentRow.views.append(view)
            currentRow.height = max(currentRow.height, size.height)
            x += size.width + spacing
        }
        
        if !currentRow.views.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
    
    struct Row {
        var views: [LayoutSubview] = []
        var height: CGFloat = 0
    }
}
