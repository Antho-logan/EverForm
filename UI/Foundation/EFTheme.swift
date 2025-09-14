import SwiftUI

// MARK: - EFTheme Protocol
public protocol EFTheme {
    var background: Color { get }
    var surface: Color { get }
    var surfaceElevated: Color { get }
    var card: Color { get }
    var cardElevated: Color { get }
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    var textTertiary: Color { get }
    var accent: Color { get }
    var accentSuccess: Color { get }
    var accentWarning: Color { get }
    var accentDanger: Color { get }
    var accentNutrition: Color { get }
    var accentRecovery: Color { get }
    var accentMobility: Color { get }
    var border: Color { get }
    var borderHairline: Color { get }
    var divider: Color { get }
    var fill: Color { get }
    var overlay: Color { get }
    var barBackground: Color { get }
    var labelPrimary: Color { get }
    var labelSecondary: Color { get }
    var chatBot: Color { get }
    var chatUser: Color { get }
    var bg: Color { get }
    var bgElevated: Color { get }
    var shadow: Color { get }
}

// MARK: - Environment Key
private struct EFThemeKey: EnvironmentKey {
    static let defaultValue: EFTheme = DarkTheme()
}

extension EnvironmentValues {
    var efTheme: EFTheme {
        get { self[EFThemeKey.self] }
        set { self[EFThemeKey.self] = newValue }
    }
}

// MARK: - Dark Theme Implementation
public struct DarkTheme: EFTheme {
    public let background = Color(hex: "0B0B0D")
    public let surface = Color(hex: "1A1B1E")
    public let surfaceElevated = Color(hex: "232529")
    public let card = Color(hex: "232529")
    public let cardElevated = Color(hex: "2A2C30")
    public let textPrimary = Color(hex: "FFFFFF")
    public let textSecondary = Color(hex: "A0A0A0")
    public let textTertiary = Color(hex: "808080")
    public let accent = Color(hex: "0A84FF")
    public let accentSuccess = Color(hex: "32D74B")
    public let accentWarning = Color(hex: "FF9F0A")
    public let accentDanger = Color(hex: "FF453A")
    public let accentNutrition = Color(hex: "FF9F0A")
    public let accentRecovery = Color(hex: "BF5AF2")
    public let accentMobility = Color(hex: "64D2FF")
    public let border = Color(hex: "383A3E")
    public let borderHairline = Color(hex: "383A3E")
    public let divider = Color(hex: "383A3E")
    public let fill = Color(hex: "383A3E")
    public let overlay = Color(hex: "000000", alpha: 0.4)
    public let barBackground = Color(hex: "111214")
    public let labelPrimary = Color(hex: "FFFFFF")
    public let labelSecondary = Color(hex: "A0A0A0")
    public let chatBot = Color(hex: "1A1B1E")
    public let chatUser = Color(hex: "0A84FF")
    public let bg = Color(hex: "0B0B0D")
    public let bgElevated = Color(hex: "1A1B1E")
    public let shadow = Color(hex: "000000", alpha: 0.3)
    
    public init() {}
}

// MARK: - Theme Provider
public struct EFThemeProvider: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var appearance: AppearanceStore
    
    public func body(content: Content) -> some View {
        content
            .environment(\.efTheme, DarkTheme())
    }
}

extension View {
    public func withEFTheme() -> some View {
        self.modifier(EFThemeProvider())
    }
}