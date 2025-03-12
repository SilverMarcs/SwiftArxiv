//
//  PDFHandlerService.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import Foundation
import AppKit

class PDFHandlerService {
    enum PDFError: LocalizedError {
        case downloadFailed(Error)
        case saveFailed(Error)
        
        var errorDescription: String? {
            switch self {
            case .downloadFailed(let error):
                return "Download failed: \(error.localizedDescription)"
            case .saveFailed(let error):
                return "Save failed: \(error.localizedDescription)"
            }
        }
    }
    
    func downloadPDFToDownloads(from url: URL, title: String) async throws {
        let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let sanitizedTitle = FileUtilities.sanitizeFilename(title)
        let destination = FileUtilities.getUniqueFilename(baseURL: downloadsURL, filename: sanitizedTitle, extension: "pdf")
        
        let (data, _) = try await URLSession.shared.data(from: url)
        try data.write(to: destination)
    }
    
    func downloadAndOpenPDF(from url: URL, title: String) async throws {
        let sanitizedTitle = FileUtilities.sanitizeFilename(title)
        let destination = FileManager.default.temporaryDirectory
            .appendingPathComponent(sanitizedTitle)
            .appendingPathExtension("pdf")
        
        let (data, _) = try await URLSession.shared.data(from: url)
        try data.write(to: destination)
        NSWorkspace.shared.open(destination)
    }
}
