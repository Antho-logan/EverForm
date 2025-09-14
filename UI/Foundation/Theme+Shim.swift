import SwiftUI

// Adapter shim to preserve older call sites like Theme.semantic(...)
enum ThemeShim {
    struct Semantic {
        // Map to our current design system tokens
        // Expand ONLY as errors demand
        static var cardBackground: Color { DSColor.card }          // e.g. old: Theme.semantic.cardBackground
        static var canvasBackground: Color { DSColor.bg }  // e.g. old: Theme.semantic.canvas
        static var mutedText: Color { DSColor.labelSecondary }
    }
}

extension LegacyTheme {
    static var semantic: ThemeShim.Semantic { .init() }
}