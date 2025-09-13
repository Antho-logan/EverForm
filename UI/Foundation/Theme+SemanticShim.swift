import SwiftUI

/// Non-invasive shim to satisfy `Theme.semantic(_:)` references without altering visuals.
enum EFThemeShim {
    struct Semantic {
        let canvas: Color
        let card: Color
        let textPrimary: Color
        let textSecondary: Color
    }
    static func semantic(_ scheme: ColorScheme?) -> Semantic {
        // Reuse your current design system tokens to avoid visual changes.
        // If these tokens differ in your codebase, map them accordingly.
        let canvas = DesignSystem.Colors.backgroundSecondary
        let card = Color(.systemBackground)
        return .init(
            canvas: canvas,
            card: card,
            textPrimary: .primary,
            textSecondary: .secondary
        )
    }
}

// If some files still call `Theme.semantic`, forward them here:
extension Theme {
    static func semantic(_ scheme: ColorScheme?) -> EFThemeShim.Semantic {
        EFThemeShim.semantic(scheme)
    }
}