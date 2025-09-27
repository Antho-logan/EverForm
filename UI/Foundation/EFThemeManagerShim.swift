import SwiftUI

// Define EFThemeStyle locally to avoid importing from DesignSystem
enum EFThemeStyle: String { case system, light, dark }

@MainActor
final class EFThemeManager: ObservableObject {
    @Published var colorScheme: ColorScheme = .light

    var isDark: Bool { colorScheme == .dark }
    var isLight: Bool { colorScheme == .light }

    func isDark(_ scheme: ColorScheme) -> Bool {
        return scheme == .dark
    }

    func apply(_ scheme: ColorScheme) {
        colorScheme = scheme
    }

    func apply(style: EFThemeStyle) {
        switch style {
        case .system:
            // For system, we don't change the published colorScheme
            // as it should follow the system setting
            break
        case .light:
            colorScheme = .light
        case .dark:
            colorScheme = .dark
        }
    }

    // Add tokens property to match expected API
    var tokens: EFColorTokens {
        return EFColorTokens()
    }
}

// Some parts of the codebase reference `ThemeManager`.
// Keep those working via a typealias.
typealias ThemeManager = EFThemeManager

// Also provide the original EFThemeManager name for compatibility
typealias OriginalEFThemeManager = EFThemeManager
