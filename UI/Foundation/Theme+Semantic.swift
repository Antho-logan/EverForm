import SwiftUI

extension Theme {
    struct SemanticColors {
        public let page: Color
        public let card: Color
        public let cardStroke: Color
        public let textPrimary: Color
        public let textSecondary: Color
        public let accent: Color
        public let danger: Color        // red for destructive actions
        public let success: Color       // green for success states
        public let info: Color          // blue for informational states
        public let water: Color         // teal/blue for water-related actions
    }

    static func semantic(_ colorScheme: ColorScheme) -> SemanticColors {
        // Safe RGB helper – avoids crashing Color(hex:) extensions
        func rgb(_ hex: UInt32) -> Color {
            let r = Double((hex >> 16) & 0xFF) / 255.0
            let g = Double((hex >> 8) & 0xFF) / 255.0
            let b = Double(hex & 0xFF) / 255.0
            return Color(red: r, green: g, blue: b)
        }

        let beigePage   = DSColor.appBackground ?? DesignSystem.Colors.backgroundSecondary ?? rgb(0xEAD8C2)
        let beigeCard   = DSColor.card ?? rgb(0xF7EFE6)
        let beigeStroke = Color.black.opacity(0.06)

        let lightPage   = Color.white
        let lightCard   = rgb(0xF7F7F7)
        let lightStroke = Color.black.opacity(0.06)

        let darkPage    = rgb(0x0F0F10)
        let darkCard    = rgb(0x1A1A1C)
        let darkStroke  = Color.white.opacity(0.08)

        let accent      = DSColor.accentPrimary ?? Color.accentColor
        let textPrimaryLight   = Color.black
        let textSecondaryLight = Color.black.opacity(0.6)
        let textPrimaryDark    = Color.white
        let textSecondaryDark  = Color.white.opacity(0.7)

        enum Mode { case systemBeige, light, dark }
        let explicit: AppearanceStore.Mode? = {
            let store = AppearanceStore()
            return store.mode
        }()
        let mode: Mode = {
            if let explicit {
                switch explicit {
                case .system: return .systemBeige
                case .light:  return .light
                case .dark:   return .dark
                }
            }
            return (colorScheme == .dark) ? .dark : .systemBeige
        }()

        switch mode {
        case .systemBeige:
            return SemanticColors(
                page: beigePage, card: beigeCard, cardStroke: beigeStroke,
                textPrimary: textPrimaryLight, textSecondary: textSecondaryLight,
                accent: accent,
                danger: rgb(0xDC2626),    // red for destructive actions
                success: rgb(0x16A34A),   // green for success states  
                info: rgb(0x2563EB),      // blue for informational states
                water: rgb(0x0891B2)      // teal/blue for water-related actions
            )
        case .light:
            return SemanticColors(
                page: lightPage, card: lightCard, cardStroke: lightStroke,
                textPrimary: textPrimaryLight, textSecondary: textSecondaryLight,
                accent: accent,
                danger: rgb(0xDC2626),    // red for destructive actions
                success: rgb(0x16A34A),   // green for success states
                info: rgb(0x2563EB),      // blue for informational states
                water: rgb(0x0891B2)      // teal/blue for water-related actions
            )
        case .dark:
            return SemanticColors(
                page: darkPage, card: darkCard, cardStroke: darkStroke,
                textPrimary: textPrimaryDark, textSecondary: textSecondaryDark,
                accent: accent,
                danger: rgb(0xEF4444),    // red for destructive actions
                success: rgb(0x22C55E),   // green for success states
                info: rgb(0x3B82F6),      // blue for informational states
                water: rgb(0x06B6D4)      // teal/blue for water-related actions
            )
        }
    }
}