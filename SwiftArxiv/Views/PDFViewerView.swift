//
//  PDFViewerView.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI
import PDFKit
import UniformTypeIdentifiers

struct PDFViewerView: View {
    let url: URL
    @State private var invertColors = false
    
    var body: some View {
        PDFKitView(url: url)
            .if(invertColors) {
                $0.colorInvert()
            }
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Button {
                        invertColors.toggle()
                    } label: {
                        Image(systemName: (invertColors ? "sun.min.fill" : "moon.fill"))
                    }
                }
            }
    }
}
