import SwiftUI

// MARK: - EFThemeProtocol Protocol
public protocol EFThemeProtocol {
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
    var inputBackground: Color { get }
}

// MARK: - Environment Key
private struct EFThemeKey: EnvironmentKey {
    static let defaultValue: EFThemeProtocol = DarkTheme()
}

extension EnvironmentValues {
    var efTheme: EFThemeProtocol {
        get { self[EFThemeKey.self] }
        set { self[EFThemeKey.self] = newValue }
    }
}

// MARK: - Dark Theme Implementation
public struct DarkTheme: EFThemeProtocol {
    public let background = Color("AppBackground")
    public let surface = Color("Surface")
    public let surfaceElevated = Color("CardElevated")
    public let card = Color("Card")
    public let cardElevated = Color("CardElevated")
    public let textPrimary = Color("TextPrimary")
    public let textSecondary = Color("TextSecondary")
    public let textTertiary = Color.secondary
    public let accent = Color("AccentColor")
    public let accentSuccess = Color.green
    public let accentWarning = Color.orange
    public let accentDanger = Color.red
    public let accentNutrition = Color.orange
    public let accentRecovery = Color.purple
    public let accentMobility = Color.blue
    public let border = Color("TextSecondary").opacity(0.3)
    public let borderHairline = Color("TextSecondary").opacity(0.2)
    public let divider = Color("TextSecondary").opacity(0.3)
    public let fill = Color.gray
    public let overlay = Color.black.opacity(0.4)
    public let barBackground = Color("AppBackground")
    public let labelPrimary = Color("TextPrimary")
    public let labelSecondary = Color("TextSecondary")
    public let chatBot = Color("ChatBubbleBot")
    public let chatUser = Color("ChatBubbleUser")
    public let bg = Color("AppBackground")
    public let bgElevated = Color("Surface")
    public let shadow = Color.black.opacity(0.3)
    public let inputBackground = Color("CardElevated")

    public init() {}
}

// MARK: - Theme Provider
public struct EFThemeProvider: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

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