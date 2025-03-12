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
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
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
                        
                        // Action buttons (non-PDF ones)
                        HStack(spacing: 12) {
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
            .toolbar {
                if let pdfUrl = article.pdfUrl {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Group {
                            Button {
                                downloadAndOpenPDF(from: pdfUrl)
                            } label: {
                                if isDownloadingPDF {
                                    ProgressView()
                                        .controlSize(.small)
                                } else {
                                    Label("Open in Preview", systemImage: "doc.text.fill")
                                        .labelStyle(.titleOnly)
                                }
                            }
                            .disabled(isDownloadingPDF)
                            
                            Button {
                                downloadPDFToDownloads(from: pdfUrl)
                            } label: {
                                if isDownloadingPDF {
                                    ProgressView()
                                        .controlSize(.small)
                                } else {
                                    Label("Download", systemImage: "arrow.down.circle")
                                }
                            }
                            .disabled(isDownloadingPDF)
                        }
                        
                        NavigationLink {
                            PDFViewerView(url: pdfUrl)
                                .navigationTitle("PDF Preview")
                                .toolbarTitleDisplayMode(.inline)
                        } label: {
                            Image(systemName: "eye.fill")
                        }
                        .help("Preview PDF")
                    }
                }
            }
        }
        .background(.background)
        .scrollContentBackground(.visible)
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func sanitizeFilename(_ filename: String) -> String {
        // Replace characters that are problematic in filenames
        let invalidCharacters = CharacterSet(charactersIn: ":/\\?%*|\"<>")
        return filename.components(separatedBy: invalidCharacters)
            .joined(separator: "-")
            .trimmingCharacters(in: .whitespaces)
    }
    
    private func getUniqueFilename(baseURL: URL, filename: String, extension: String) -> URL {
        var finalURL = baseURL.appendingPathComponent(filename).appendingPathExtension(`extension`)
        var counter = 1
        
        while FileManager.default.fileExists(atPath: finalURL.path) {
            let newFilename = "\(filename) (\(counter))"
            finalURL = baseURL.appendingPathComponent(newFilename).appendingPathExtension(`extension`)
            counter += 1
        }
        
        return finalURL
    }
    
    private func downloadPDFToDownloads(from url: URL) {
        isDownloadingPDF = true
        
        // Get Downloads directory
        let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let sanitizedTitle = sanitizeFilename(article.title)
        let destination = getUniqueFilename(baseURL: downloadsURL, filename: sanitizedTitle, extension: "pdf")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isDownloadingPDF = false
                
                if let error = error {
                    self.alertTitle = "Download Failed"
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                    return
                }
                
                if let data = data {
                    do {
                        try data.write(to: destination)
                        self.alertTitle = "Download Complete"
                        self.alertMessage = "PDF has been saved to Downloads folder"
                        self.showingAlert = true
                    } catch {
                        self.alertTitle = "Save Failed"
                        self.alertMessage = error.localizedDescription
                        self.showingAlert = true
                    }
                }
            }
        }.resume()
    }
    
    private func downloadAndOpenPDF(from url: URL) {
        isDownloadingPDF = true
        
        let sanitizedTitle = sanitizeFilename(article.title)
        let destination = FileManager.default.temporaryDirectory
            .appendingPathComponent(sanitizedTitle)
            .appendingPathExtension("pdf")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isDownloadingPDF = false
                
                if let error = error {
                    self.alertTitle = "Download Failed"
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                    return
                }
                
                if let data = data {
                    do {
                        try data.write(to: destination)
                        NSWorkspace.shared.open(destination)
                    } catch {
                        self.alertTitle = "Save Failed"
                        self.alertMessage = error.localizedDescription
                        self.showingAlert = true
                    }
                }
            }
        }.resume()
    }
}
