//
//  SummarizeService.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import Foundation
import PDFKit
import SwiftUI

actor SummarizeService {
    @AppStorage("geminiApiKey") private var geminiApiKey: String = ""
    
    struct GeminiRequest: Codable {
        let model: String
        let messages: [Message]
        
        struct Message: Codable {
            let role: String
            let content: String
        }
    }
    
    struct GeminiResponse: Codable {
        let choices: [Choice]
        
        struct Choice: Codable {
            let message: Message
            
            struct Message: Codable {
                let content: String
            }
        }
    }
    
    func extractTextFromPDF(at url: URL) async throws -> String {
        guard let document = PDFDocument(url: url) else {
            throw NSError(domain: "PDFExtraction", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not load PDF"])
        }
        
        var text = ""
        for i in 0..<document.pageCount {
            if let page = document.page(at: i) {
                if let pageText = page.string {
                    text += pageText + "\n"
                }
            }
        }
        return text
    }
    
    func summarize(pdfText: String) async throws -> String {
        let request = GeminiRequest(
            model: "gemini-2.0-flash",
            messages: [
                GeminiRequest.Message(
                    role: "user",
                    content: pdfText + "\n\nSummarise the research paper"
                )
            ]
        )
        
        let jsonData = try JSONEncoder().encode(request)
        
        var urlRequest = URLRequest(url: URL(string: "https://generativelanguage.googleapis.com/v1beta/openai/chat/completions")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(geminiApiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let response = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
        return response.choices.first?.message.content ?? "No summary available"
    }
}
