import SwiftUI

enum ArticleCategory: String {
    case computerScience
    case economics
    case electricalEngineering
    case mathematics 
    case statistics
    case other
    
    init(from categoryString: String) {
        let prefix = categoryString.split(separator: ".").first?.lowercased() ?? ""
        switch prefix {
        case "cs":
            self = .computerScience
        case "econ":
            self = .economics
        case "eess":
            self = .electricalEngineering
        case "math":
            self = .mathematics
        case "stat":
            self = .statistics
        default:
            self = .other
        }
    }
    
    var iconName: String {
        switch self {
        case .computerScience:
            return "desktopcomputer"
        case .economics:
            return "chart.line.uptrend.xyaxis"
        case .electricalEngineering:
            return "bolt.fill"
        case .mathematics:
            return "function"
        case .statistics:
            return "chart.bar.fill"
        case .other:
            return "doc.text.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .computerScience:
            return .accentColor
        case .economics:
            return .green
        case .electricalEngineering:
            return .yellow
        case .mathematics:
            return .purple
        case .statistics:
            return .orange
        case .other:
            return .cyan
        }
    }
}
