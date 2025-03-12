//
//  ArticleDetailView.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    @State private var isDownloadingPDF = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
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
                                Button {
                                    downloadAndOpenPDF(from: pdfUrl)
                                } label: {
                                    if isDownloadingPDF {
                                        Label("Downloading...", systemImage: "arrow.down.circle")
                                    } else {
                                        Label("PDF", systemImage: "doc.text.fill")
                                    }
                                }
                                .disabled(isDownloadingPDF)
                                
                                NavigationLink {
                                    PDFViewerView(url: pdfUrl)
                                        .navigationTitle("PDF Preview")
                                        .toolbarTitleDisplayMode(.inline)
                                } label: {
                                    Label("Preview", systemImage: "eye.fill")
                                }
                            }
                            
                            if let htmlUrl = article.htmlUrl {
                                Link(destination: htmlUrl) {
                                    Label("Web", systemImage: "safari.fill")
                                }
                                .buttonStyle(.bordered)
                                .tint(.blue)
                            }
                            
                            if let doiUrl = article.doiUrl {
                                Link(destination: doiUrl) {
                                    Label("DOI", systemImage: "link")
                                }
                                .buttonStyle(.bordered)
                                .tint(.green)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Abstract
                    if let abstract = article.abstract {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Abstract", systemImage: "text.justify")
                                .font(.headline)
                                .foregroundColor(.blue)
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
                                .foregroundColor(.blue)
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
                                .foregroundColor(.blue)
                            
                            HStack {
                                ForEach(article.categories, id: \.self) { category in
                                    Text(category)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.green.opacity(0.1))
                                        .foregroundStyle(.green)
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
    
    private func downloadAndOpenPDF(from url: URL) {
        isDownloadingPDF = true
        
        let destination = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("pdf")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { isDownloadingPDF = false }
            
            if let data = data {
                do {
                    try data.write(to: destination)
                    DispatchQueue.main.async {
                        NSWorkspace.shared.open(destination)
                    }
                } catch {
                    print("Error saving PDF: \(error)")
                }
            }
        }.resume()
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
