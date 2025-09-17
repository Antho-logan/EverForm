import SwiftUI

/// Central text roles we use across the app.
public enum EFTextRole: String, CaseIterable {
    case primary     // default body/labels
    case secondary   // subtitles, metadata
    case muted       // disabled/tertiary
    case inverse     // text on colored surfaces (buttons/pills)
    case header      // large titles/section headers
}

// Back-compat if some files referenced TextRole previously.
public typealias TextRole = EFTextRole

/// Maps text roles to colors for the current ColorScheme.
public struct EFTextTheme {
    public static func color(for role: EFTextRole,
                             scheme: ColorScheme,
                             accent: Color = .accentColor) -> Color {
        switch (role, scheme) {
        case (.primary, .dark):
            return Color.white
        case (.secondary, .dark):
            return Color.white.opacity(0.72)
        case (.muted, .dark):
            return Color.white.opacity(0.5)
        case (.inverse, .dark):
            return Color.black.opacity(0.92)
        case (.header, .dark):
            return Color.white

        case (.primary, .light):
            return Color.black.opacity(0.92)
        case (.secondary, .light):
            return Color.black.opacity(0.6)
        case (.muted, .light):
            return Color.black.opacity(0.4)
        case (.inverse, .light):
            return Color.white
        case (.header, .light):
            return Color.black.opacity(0.92)
        @unknown default:
            return .primary
        }
    }
}

// MARK: - Environment Support for legacy compatibility
public struct EFTextThemeEnvironment {
    let headerPrimary: Color
    let headerSecondary: Color
    
    public static func current(for scheme: ColorScheme) -> EFTextThemeEnvironment {
        if scheme == .dark {
            return EFTextThemeEnvironment(
                headerPrimary: .white,
                headerSecondary: .white.opacity(0.7)
            )
        } else {
            return EFTextThemeEnvironment(
                headerPrimary: Color.black.opacity(0.92),
                headerSecondary: Color.black.opacity(0.6)
            )
        }
    }
}

private struct EFTextThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue = EFTextThemeEnvironment.current(for: .light)
}

extension EnvironmentValues {
    public var efTextTheme: EFTextThemeEnvironment {
        get { self[EFTextThemeEnvironmentKey.self] }
        set { self[EFTextThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - Theme Provider
public struct EFTextThemeProvider: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    
    public func body(content: Content) -> some View {
        content.environment(\.efTextTheme, EFTextThemeEnvironment.current(for: scheme))
    }
}

public extension View {
    func efProvideTextTheme() -> some View {
        modifier(EFTextThemeProvider())
    }
}

/// ViewModifier to apply a semantic text role.
/// Usage: Text("Hello").efText(.secondary)
public struct EFTextModifier: ViewModifier {
    public let role: EFTextRole
    @Environment(\.colorScheme) private var scheme

    public init(role: EFTextRole) {
        self.role = role
    }
    
    public func body(content: Content) -> some View {
        content.foregroundStyle(EFTextTheme.color(for: role, scheme: scheme))
    }
}

public extension View {
    @inlinable
    func efText(_ role: EFTextRole = .primary) -> some View {
        modifier(EFTextModifier(role: role))
    }
}