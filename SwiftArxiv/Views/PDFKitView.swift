//
//  PDFKitView.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI
import PDFKit

struct PDFKitView: View {
    let url: URL
    @State private var isLoading = true
    @State private var loadError: Error?
    
    var body: some View {
        ZStack {
            PDFKitRepresentedView(url: url, isLoading: $isLoading, loadError: $loadError)
                .opacity(isLoading ? 0 : 1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if isLoading {
                ProgressView()
            }
            
            if let error = loadError {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("Failed to load PDF")
                        .font(.headline)
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#if os(macOS)
struct PDFKitRepresentedView: NSViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var loadError: Error?
    
    func makeNSView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.autoScales = true
        pdfView.backgroundColor = .clear
        return pdfView
    }
    
    func updateNSView(_ pdfView: PDFKit.PDFView, context: Context) {
        loadPDF(into: pdfView)
    }
}
#else
struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var loadError: Error?
    
    func makeUIView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFKit.PDFView, context: Context) {
        loadPDF(into: pdfView)
    }
}
#endif

extension PDFKitRepresentedView {
    private func loadPDF(into pdfView: PDFKit.PDFView) {
        Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: 1) // Ensure view is ready
                guard let document = PDFDocument(url: url) else {
                    loadError = NSError(domain: "PDFKitView", code: -1, 
                                     userInfo: [NSLocalizedDescriptionKey: "Could not load PDF"])
                    return
                }
                pdfView.document = document
            } catch {
                loadError = error
            }
            isLoading = false
        }
    }
}
