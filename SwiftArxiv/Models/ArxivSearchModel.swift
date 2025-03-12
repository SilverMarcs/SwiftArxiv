//
//  ArxivSearchModel.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI
import FeedKit

@Observable
class ArxivSearchModel {
    var searchQuery = ""
    var isLoading = false
    var articles: [Article] = []
    var selectedArticle: Article?
    var errorMessage: String?
    
    func searchArticles() async {
        guard !searchQuery.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        // Format the query for the API
        let formattedQuery = searchQuery
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)?
            .replacingOccurrences(of: "%20", with: "+") ?? ""
        
        guard let apiURL = URL(string: "http://export.arxiv.org/api/query?search_query=ti:\(formattedQuery)&sortBy=relevance&max_results=100") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let feed = try await AtomFeed(url: apiURL)
            
            // Update on the main thread
            await MainActor.run {
                self.articles = (feed.entries ?? []).map(Article.init)
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Error: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}
