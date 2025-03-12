//
//  ArticleToolbar.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI

struct ArticleToolbar: ToolbarContent {
    let article: Article
    @Binding var isDownloadingPDF: Bool
    @Binding var isOpeningInPreview: Bool
    @Binding var isSummarizing: Bool
    let onSummarize: () async -> Void
    let onDownload: () -> Void
    let onOpenInPreview: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                Task {
                    await onSummarize()
                }
            } label: {
                if isSummarizing {
                    ProgressView()
                        .controlSize(.small)
                } else {
                    Label("Summarize", systemImage: "sparkles")
                }
            }
            .disabled(isSummarizing)
            .help("Summarize paper using AI")
            
            if let htmlUrl = article.htmlUrl {
                Link(destination: htmlUrl) {
                    Label("Web", systemImage: "safari")
                }
                .buttonStyle(.bordered)
                .tint(.blue)
            }
            
            Group {
                Button {
                    onDownload()
                } label: {
                    if isDownloadingPDF {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Label("Download", systemImage: "arrow.down.circle")
                    }
                }
                .disabled(isDownloadingPDF)

                Button {
                    onOpenInPreview()
                } label: {
                    Label(isOpeningInPreview ? "Opening..." : "Open in Preview", systemImage: "doc.text.fill")
                        .labelStyle(.titleOnly)
                }
                .disabled(isOpeningInPreview)
            }
        }
    }
}
