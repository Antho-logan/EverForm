import SwiftUI

// Legacy compatibility aliases
typealias EFColor = DSColor
// Note: EFTheme is now an enum in Theme+Semantic.swift - not a typealias

// Legacy EFAppearance enum
enum EFAppearance: String, CaseIterable {
    case system, light, dark
}