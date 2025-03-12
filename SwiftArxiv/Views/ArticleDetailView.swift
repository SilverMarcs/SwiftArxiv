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
    @State private var isOpeningInPreview = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var isSummarizing = false
    @State private var showingSummary = false
    @State private var summary = ""
    
    private let summarizeService = SummarizeService()
    private let pdfHandler = PDFHandlerService()
    
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
                    // Abstract
                    if let abstract = article.abstract {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Abstract", systemImage: "text.justify")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.blue)
                            Text(abstract)
                                .textSelection(.enabled)
                        }
                        
                        Divider()
                    }
                    
                    // Authors
                    if !article.authors.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Authors", systemImage: "person.2")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.orange)
                            Text(article.authors.joined(separator: ", "))
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
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.green)
                            
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
                ArticleToolbar(
                    article: article,
                    isDownloadingPDF: $isDownloadingPDF,
                    isOpeningInPreview: $isOpeningInPreview,
                    isSummarizing: $isSummarizing,
                    onSummarize: {
                        if let pdfUrl = article.pdfUrl {
                            await summarizePDF(from: pdfUrl)
                        }
                    },
                    onDownload: {
                        if let pdfUrl = article.pdfUrl {
                            downloadPDFToDownloads(from: pdfUrl)
                        }
                    },
                    onOpenInPreview: {
                        if let pdfUrl = article.pdfUrl {
                            downloadAndOpenPDF(from: pdfUrl)
                        }
                    }
                )
            }
            .navigationTitle(article.title)
            .background(.background)
            .scrollContentBackground(.visible)
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .sheet(isPresented: $showingSummary) {
                NavigationStack {
                    ScrollView {
                        Text(summary)
                            .textSelection(.enabled)
                            .padding()
                    }
                    .navigationTitle("Summary")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showingSummary = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func summarizePDF(from url: URL) async {
        isSummarizing = true
        
        do {
            let pdfText = try await summarizeService.extractTextFromPDF(at: url)
            summary = try await summarizeService.summarize(pdfText: pdfText)
            showingSummary = true
        } catch {
            alertTitle = "Summarization Failed"
            alertMessage = error.localizedDescription
            showingAlert = true
        }
        
        isSummarizing = false
    }
    
    private func downloadPDFToDownloads(from url: URL) {
        isDownloadingPDF = true
        
        Task {
            do {
                try await pdfHandler.downloadPDFToDownloads(from: url, title: article.title)
                alertTitle = "Download Complete"
                alertMessage = "PDF has been saved to Downloads folder"
            } catch {
                alertTitle = "Download Failed"
                alertMessage = error.localizedDescription
            }
            showingAlert = true
            isDownloadingPDF = false
        }
    }
    
    private func downloadAndOpenPDF(from url: URL) {
        isOpeningInPreview = true
        
        Task {
            do {
                try await pdfHandler.downloadAndOpenPDF(from: url, title: article.title)
            } catch {
                alertTitle = "Failed to Open PDF"
                alertMessage = error.localizedDescription
                showingAlert = true
            }
            isOpeningInPreview = false
        }
    }
}
