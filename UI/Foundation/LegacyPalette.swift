import SwiftUI

// Adapter for legacy palette references
enum LegacyPalette {
    static var background: Color { DSColor.bg }
    static var textPrimary: Color { DSColor.labelPrimary }
    static var textSecondary: Color { DSColor.labelSecondary }
    static var accent: Color { DSColor.accentSuccess }
}

// Fix for palette references in preview contexts
enum Palette {
    static var background: Color { DSColor.bg }
    static var textPrimary: Color { DSColor.labelPrimary }
    static var textSecondary: Color { DSColor.labelSecondary }
    static var accent: Color { DSColor.accentSuccess }
}