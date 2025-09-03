import SwiftUI

public enum EFUserTheme: String, CaseIterable {
    case system, light, dark
}

public final class EFTheme: ObservableObject {
    @AppStorage("ef.colorScheme") private var stored: String = EFUserTheme.system.rawValue
    @Published public var selection: EFUserTheme

    public static let shared = EFTheme()

    private init() {
        selection = EFUserTheme(rawValue: stored) ?? .system
    }

    public func set(_ theme: EFUserTheme) {
        selection = theme
        stored = theme.rawValue
    }

    // For SwiftUI .preferredColorScheme binding
    public var preferredScheme: ColorScheme? {
        switch selection {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

// Design tokens used across the app
public struct DSColor {
    public static var appBackground: Color { Color("AppBackground") }
    public static var surface: Color       { Color("Surface") }
    public static var card: Color          { Color("Card") }
    public static var cardElevated: Color  { Color("CardElevated") }
    public static var textPrimary: Color   { Color("TextPrimary") }
    public static var textSecondary: Color { Color("TextSecondary") }
}
