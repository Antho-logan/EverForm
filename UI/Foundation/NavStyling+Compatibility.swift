import SwiftUI

// Navigation styling utilities for compatibility
enum NavBlendLocal {
    static func apply() {
        // Apply navigation bar styling
        UINavigationBar.appearance().standardAppearance = UINavigationBarAppearance()
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
    }
}

enum EFNavBarStyler {
    static func resetToDefault() {
        // Reset navigation bar to default styling
        UINavigationBar.appearance().standardAppearance = UINavigationBarAppearance()
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
    }
}

// User theme enum for compatibility
enum EFUserTheme: String, CaseIterable {
    case system
    case light
    case dark
}

// Nutrition navigation styling for compatibility
enum NUTRNavStylerLocal {
    static func apply() {
        // Apply nutrition-specific navigation styling
        UINavigationBar.appearance().standardAppearance = UINavigationBarAppearance()
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
    }
    
    static func apply(background: UIColor) {
        // Apply nutrition-specific navigation styling with background
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = background
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    static func reset() {
        // Reset navigation styling to default
        UINavigationBar.appearance().standardAppearance = UINavigationBarAppearance()
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
    }
}

// Semantic colors for compatibility
struct SemanticColors {
    var page: Color { DSColor.bg }
}

let semanticColors = SemanticColors()

