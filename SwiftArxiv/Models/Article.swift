//
//  Article.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import Foundation
import FeedKit
import SwiftData

@Model
class Article {
    var id: String
    var title: String
    var abstract: String?
    var authors: [String]
    var published: Date?
    var updated: Date?
    var categories: [String]
    var primaryCategory: String?
    var pdfUrl: URL?
    var htmlUrl: URL?
    var doiUrl: URL?
    var journalRef: String?
    var comment: String?
    
    init(from entry: AtomFeedEntry) {
        self.id = entry.id ?? UUID().uuidString
        self.title = entry.title ?? "Untitled"
        self.abstract = entry.summary?.text
        self.authors = entry.authors?.compactMap { $0.name } ?? []
        self.published = entry.published
        self.updated = entry.updated
        self.categories = entry.categories?.compactMap { $0.attributes?.term } ?? []
        self.primaryCategory = entry.categories?.first?.attributes?.term
        // Journal ref and comments will be extracted from XML-level nodes
        // Setting to nil for now until we figure out the correct FeedKit access pattern
        self.journalRef = nil  // TODO: Find correct access path for journal_ref
        self.comment = nil     // TODO: Find correct access path for comment
        
        // Extract URLs
        self.pdfUrl = entry.links?.first(where: { $0.attributes?.title == "pdf" })?.attributes?.href.flatMap(URL.init)
        self.htmlUrl = entry.links?.first(where: { $0.attributes?.rel == "alternate" })?.attributes?.href.flatMap(URL.init)
        self.doiUrl = entry.links?.first(where: { $0.attributes?.title == "doi" })?.attributes?.href.flatMap(URL.init)
    }
}
