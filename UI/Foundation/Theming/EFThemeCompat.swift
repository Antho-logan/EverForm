import SwiftUI

// MARK: - Styles
public enum EFThemeStyle {
    case system, light, dark
}

// MARK: - Color Tokens (bridge to DSColor)
public struct EFCompatColorTokens {
    public init() {}
    public var bg: Color { DSColor.bg }
    public var card: Color { DSColor.card }
    public var textPrimary: Color { DSColor.textPrimary }
    public var textSecondary: Color { DSColor.textSecondary }
    public var accentPrimary: Color { DSColor.accentPrimary }

    // Dark theme variants
    public var textPrimaryDark: Color { DSColor.textPrimary }
    public var textSecondaryDark: Color { DSColor.textSecondary }
    public var textPrimaryLight: Color { DSColor.textPrimary }
    public var textSecondaryLight: Color { DSColor.textSecondary }
    public var fieldFillDark: Color { DSColor.bg }
    public var fieldFillLight: Color { DSColor.bg }
    public var fieldBorderDark: Color { DSColor.borderHairline }
    public var fieldBorderLight: Color { DSColor.borderHairline }
}

// MARK: - Theme Manager (back-compat)
public final class EFThemeManager: ObservableObject {
    public static let shared = EFThemeManager()
    public let tokens = EFCompatColorTokens()

    // Add selection property to match expected API
    public var selection: EFThemeStyle = .system {
        didSet {
            // Could trigger theme changes here if needed
        }
    }

    // Add properties that tip tracker expects
    public var card: Color { tokens.card }
    public var border: Color { DSColor.borderHairline }
    public var shadow: Color { DSColor.shadow }
    public var background: Color { tokens.bg }
    public var accentNutrition: Color { DSColor.accentNutrition }
    public var accentDanger: Color { DSColor.accentDanger }
    public var textPrimary: Color { tokens.textPrimary }
    public var textSecondary: Color { tokens.textSecondary }

    public func isDark(_ scheme: ColorScheme) -> Bool { scheme == .dark }
    public func apply(style: EFThemeStyle) {
        selection = style
    }
    public func initialize() { /* no-op bridge to keep API */ }
}

// Back-compat alias some files use (but avoid ThemeManager name conflict with Theme.swift)
public typealias AppThemeManager = EFThemeManager

// MARK: - Environment bridge (EnvironmentValues.efTheme)
private struct EFThemeManagerKey: EnvironmentKey {
    static let defaultValue: EFThemeManager = .shared
}

public extension EnvironmentValues {
    var efTheme: EFThemeManager {
        get { self[EFThemeManagerKey.self] }
        set { self[EFThemeManagerKey.self] = newValue }
    }
}

// Simple class for @StateObject compatibility with EFTheme.shared
public class EFThemeShared: ObservableObject {
    public static let shared = EFThemeShared()
    @Published public var currentTheme = EFThemeStyle.system
}

// EFTheme enum already exists in Theme+Semantic.swift - no need to duplicate
