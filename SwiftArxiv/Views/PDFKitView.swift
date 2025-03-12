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
    @State private var pdfDocument: PDFDocument?
    
    var body: some View {
        ZStack {
            if let document = pdfDocument {
                PDFKitRepresentedView(document: document)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
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
        .onAppear {
            loadPDF()
        }
    }
    
    private func loadPDF() {
        isLoading = true
        
        // Load PDF in background
        DispatchQueue.global(qos: .userInitiated).async {
            let document = PDFDocument(url: url)
            
            // Update UI on main thread
            DispatchQueue.main.async {
                if let document = document {
                    self.pdfDocument = document
                } else {
                    self.loadError = NSError(domain: "PDFKitView", code: -1,
                                          userInfo: [NSLocalizedDescriptionKey: "Could not load PDF"])
                }
                self.isLoading = false
            }
        }
    }
}

#if os(macOS)
struct PDFKitRepresentedView: NSViewRepresentable {
    let document: PDFDocument
    
    func makeNSView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.autoScales = true
        pdfView.document = document
        return pdfView
    }
    
    func updateNSView(_ pdfView: PDFKit.PDFView, context: Context) {
        pdfView.document = document
    }
}
#else
struct PDFKitRepresentedView: UIViewRepresentable {
    let document: PDFDocument
    
    func makeUIView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.autoScales = true
        pdfView.document = document
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFKit.PDFView, context: Context) {
        pdfView.document = document
    }
}
#endif
