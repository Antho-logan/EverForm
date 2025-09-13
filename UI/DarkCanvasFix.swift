import SwiftUI

/// Local, file-scoped dark-theme helpers that do NOT affect System or Light.
enum EFDarkFix {
    // Neutral dark canvas (tweak if you have an official token).
    static let canvas = Color(red: 0.07, green: 0.07, blue: 0.08) // ≈ #121314

    /// Optional mirror of an app appearance override (System/Light/Dark).
    enum AppearanceOverride { case system, light, dark }

    /// True only when the app should render the DARK look.
    static func isDark(apparent colorScheme: ColorScheme,
                       appearanceOverride: AppearanceOverride?) -> Bool {
        switch appearanceOverride {
        case .some(.dark):  return true
        case .some(.light): return false
        case .some(.system), .none:
            return colorScheme == .dark
        }
    }
}

private struct DarkCanvasBackground: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    var override: EFDarkFix.AppearanceOverride? = .system

    func body(content: Content) -> some View {
        if EFDarkFix.isDark(apparent: colorScheme, appearanceOverride: override) {
            ZStack {
                EFDarkFix.canvas.ignoresSafeArea()
                content
            }
        } else {
            content
        }
    }
}

extension View {
    /// Paint a neutral dark canvas **only in Dark mode**. System & Light pass through untouched.
    func efDarkCanvas(override: EFDarkFix.AppearanceOverride? = .system) -> some View {
        modifier(DarkCanvasBackground(override: override))
    }
}