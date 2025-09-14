import SwiftUI

// Design system constants for compatibility
enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

enum Radius {
    static let card: CGFloat = 20
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let pill: CGFloat = 14
}

// Legacy Theme with palette
enum LegacyTheme {
    enum Palette {
        static func background(_ colorScheme: ColorScheme) -> Color {
            return DSColor.bg
        }
        static var textPrimary: Color { DSColor.labelPrimary }
        static var textSecondary: Color { DSColor.labelSecondary }
        static var accent: Color { DSColor.accentSuccess }
        static var surfaceElevated: Color { DSColor.bgElevated }
        static var stroke: Color { DSColor.borderHairline }
    }
    
    static var pageBackground: Color { DSColor.bg }
    
    static func palette(_ colorScheme: ColorScheme) -> some PaletteProtocol {
        return LegacyPaletteAdapter()
    }
}

// Adapter to provide instance-based access to static palette properties
struct LegacyPaletteAdapter: PaletteProtocol {
    var background: Color { DSColor.bg }
    var textPrimary: Color { DSColor.labelPrimary }
    var textSecondary: Color { DSColor.labelSecondary }
    var accent: Color { DSColor.accentSuccess }
    var surfaceElevated: Color { DSColor.bgElevated }
    var stroke: Color { DSColor.borderHairline }
    var surface: Color { DSColor.bgElevated }
}

// Protocol for palette compatibility
protocol PaletteProtocol {
    var background: Color { get }
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    var accent: Color { get }
    var surfaceElevated: Color { get }
    var stroke: Color { get }
    var surface: Color { get }
}

// Type alias for backward compatibility - maps to LegacyTheme
typealias Theme = LegacyTheme