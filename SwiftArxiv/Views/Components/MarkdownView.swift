//
//  MarkdownView.swift
//  LynkChat
//
//  Created by Zabir Raihan on 26/11/2024.
//

import SwiftUI

struct MarkdownView: View {
//    @ObservedObject private var config = AppConfig.shared
    var attributed: NSAttributedString

    var body: some View {
        Text(AttributedString(attributed)) // Convert NSAttributedString to AttributedString for SwiftUI Text
    }
    
    init(text: String) {
        self.attributed = MarkdownView.parseMarkdown(text)
    }

    private static func parseMarkdown(_ text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let scanner = Scanner(string: text)
        scanner.charactersToBeSkipped = nil

//        let baseSize = AppConfig.shared.fontSize
        let baseSize: CGFloat = 13
        
        while !scanner.isAtEnd {
            if scanner.scanString("```") != nil {
                // Skip code blocks
                let _ = scanner.scanUpToCharacters(from: .newlines) ?? ""
                let _ = scanner.scanCharacters(from: .newlines)
                
                if let codeContent = scanner.scanUpToString("```") {
                    if scanner.scanString("```") != nil {
                        // Just add as plain text
                        let text = NSAttributedString(
                            string: codeContent,
                            attributes: [
                                .font: PlatformFont.systemFont(ofSize: baseSize)
                            ]
                        )
                        attributedString.append(text)
                    } else {
                        let fallback = NSAttributedString(
                            string: "```\(codeContent)",
                            attributes: [
                                .font: PlatformFont.systemFont(ofSize: baseSize)
                            ]
                        )
                        attributedString.append(fallback)
                    }
                }
            } else if scanner.scanString("`") != nil {
                if let codeContent = scanner.scanUpToString("`") {
                    if scanner.scanString("`") != nil {
                        let inlineCode = NSAttributedString(
                            string: codeContent,
                            attributes: [
                                .font: PlatformFont.monospacedSystemFont(ofSize: baseSize - 1, weight: .regular),
                                .backgroundColor: PlatformColor.secondarySystemFill
                            ]
                        )
                        attributedString.append(inlineCode)
                    } else {
                        let fallback = NSAttributedString(
                            string: "`\(codeContent)",
                            attributes: [
                                .font: PlatformFont.systemFont(ofSize: baseSize)
                            ]
                        )
                        attributedString.append(fallback)
                    }
                }
            } else if scanner.scanString("**") != nil {
                if let boldContent = scanner.scanUpToString("**") {
                    if scanner.scanString("**") != nil {
                        let bold = NSAttributedString(
                            string: boldContent,
                            attributes: [
                                .font: PlatformFont.boldSystemFont(ofSize: baseSize)
                            ]
                        )
                        attributedString.append(bold)
                    } else {
                        let fallback = NSAttributedString(
                            string: "**\(boldContent)",
                            attributes: [
                                .font: PlatformFont.systemFont(ofSize: baseSize)
                            ]
                        )
                        attributedString.append(fallback)
                    }
                }
            } else if scanner.scanString("#") != nil {
                var headingLevel = 1
                while scanner.scanString("#") != nil {
                    headingLevel += 1
                }
                let _ = scanner.scanCharacters(from: .whitespaces)
                if let headingContent = scanner.scanUpToCharacters(from: .newlines) {
                    let headingSize: CGFloat = baseSize * (2.0 - (0.3 * CGFloat(headingLevel - 1)))
                    let heading = NSAttributedString(
                        string: headingContent,
                        attributes: [
                            .font: PlatformFont.systemFont(ofSize: headingSize, weight: .bold)
                        ]
                    )
                    attributedString.append(heading)
                }
            } else {
                if let textContent = scanner.scanUpToCharacters(from: CharacterSet(charactersIn: "`*#")) {
                    let text = NSAttributedString(
                        string: textContent,
                        attributes: [
                            .font: PlatformFont.systemFont(ofSize: baseSize)
                        ]
                    )
                    attributedString.append(text)
                } else if let char = scanner.scanCharacter() {
                    let text = NSAttributedString(
                        string: String(char),
                        attributes: [
                            .font: PlatformFont.systemFont(ofSize: baseSize)
                        ]
                    )
                    attributedString.append(text)
                }
            }
        }

        return attributedString
    }
}

#Preview {
    List {
        MarkdownView(text: "Hello, **world**!")
    }
}


// MARK: - Platform Color
#if os(macOS)
typealias PlatformColor = NSColor
typealias PlatformFont = NSFont
typealias PlatformView = NSView
typealias PlatformViewRepresentable = NSViewRepresentable
#else
typealias PlatformColor = UIColor
typealias PlatformFont = UIFont
typealias PlatformView = UIView
typealias PlatformViewRepresentable = UIViewRepresentable
#endif
