//
//  FileUtilities.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import Foundation

struct FileUtilities {
    static func sanitizeFilename(_ filename: String) -> String {
        // Replace characters that are problematic in filenames
        let invalidCharacters = CharacterSet(charactersIn: ":/\\?%*|\"<>")
        return filename.components(separatedBy: invalidCharacters)
            .joined(separator: "")
            .trimmingCharacters(in: .whitespaces)
    }
    
    static func getUniqueFilename(baseURL: URL, filename: String, extension: String) -> URL {
        var finalURL = baseURL.appendingPathComponent(filename).appendingPathExtension(`extension`)
        var counter = 1
        
        while FileManager.default.fileExists(atPath: finalURL.path) {
            let newFilename = "\(filename) (\(counter))"
            finalURL = baseURL.appendingPathComponent(newFilename).appendingPathExtension(`extension`)
            counter += 1
        }
        
        return finalURL
    }
}
