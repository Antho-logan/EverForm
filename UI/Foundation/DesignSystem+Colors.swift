import SwiftUI

enum DSColor {
    // Backgrounds
    static var bg: Color {
        switch ThemeManager.shared.scheme {
        case .dark:   return Color(hex: "#0F1114")
        case .light:  return Color(hex: "#F6F7FA")
        case .system: return Color(hex: "#E8D4B9")
        }
    }
    static var bgElevated: Color {
        switch ThemeManager.shared.scheme {
        case .dark:   return Color(hex: "#13161A")
        case .light:  return Color.white
        case .system: return Color(hex: "#E1C9AE")
        }
    }

    // Surfaces
    static var card: Color {
        switch ThemeManager.shared.scheme {
        case .dark:   return Color(hex: "#161A1F")
        case .light:  return Color.white
        case .system: return Color(hex: "#F7F2EA")
        }
    }
    static var input: Color {
        switch ThemeManager.shared.scheme {
        case .dark:   return Color(hex: "#191E24")
        case .light:  return Color.white
        case .system: return Color(hex: "#F5EFE8")
        }
    }

    // Bars
    static var barBackground: Color {
        switch ThemeManager.shared.scheme {
        case .dark:   return Color(hex: "#0F1114")
        case .light:  return Color.white
        case .system: return Color(hex: "#E6D0B8")
        }
    }

    // Lines
    static var borderHairline: Color {
        switch ThemeManager.shared.scheme {
        case .dark:   return Color(hex: "#2A3036")
        case .light:  return Color(hex: "#E5E7EB")
        case .system: return Color(hex: "#E0D3C4")
        }
    }

    // Labels
    static var labelPrimary: Color {
        switch ThemeManager.shared.scheme {
        case .dark:   return Color(hex: "#F2F2F7")
        case .light:  return Color(hex: "#111827")
        case .system: return Color(hex: "#1C1C1E")
        }
    }
    static var labelSecondary: Color {
        switch ThemeManager.shared.scheme {
        case .dark:   return Color(hex: "#C9CDD4")
        case .light:  return Color(hex: "#6B7280")
        case .system: return Color(hex: "#6B7280")
        }
    }
    
    // Legacy compatibility
    static var textPrimary: Color { labelPrimary }
    static var textSecondary: Color { labelSecondary }
    static var appBackground: Color { bg }
    static var surface: Color { bgElevated }
    
    // Accent colors (consistent across all themes)
    static var accentSuccess: Color { Color(hex: "#22C55E") }    // Green
    static var accentNutrition: Color { Color(hex: "#F97316") }  // Orange
    static var accentRecovery: Color { Color(hex: "#3B82F6") }   // Blue
    static var accentMobility: Color { Color(hex: "#A855F7") }   // Purple
    static var accentDanger: Color { Color(hex: "#EF4444") }    // Red
    static var accentInfo: Color { Color(hex: "#06B6D4") }      // Cyan
    
    // Utility colors
    static var inverse: Color { Color.white }                   // For text on colored backgrounds
    static var shadow: Color { Color.black }                    // For shadows
    
    // Legacy compatibility properties
    static var canvas: Color { bg }                            // For legacy canvas references
    static var brand: Color { accentSuccess }                  // For legacy brand references  
    static var accentTraining: Color { accentSuccess }         // For training accent
    static var painAccent: Color { accentDanger }              // For pain-related accents
    static var stroke: Color { borderHairline }               // For legacy stroke references
    static var accentPrimary: Color { accentSuccess }          // For primary accent references
    static var chatBot: Color { accentInfo }                   // For chat bot/accent references
    static var chatUser: Color { labelPrimary }               // For chat user references
    static var cardElevated: Color { bgElevated }             // For elevated card references
    static var green: Color { accentSuccess }                // For green color references
    static var surfaceLight: Color { bgElevated }           // For light surface references
    static var dividerLight: Color { borderHairline }         // For light divider references
    static var subTextLight: Color { labelSecondary }        // For light subtext references
    static var textLight: Color { labelPrimary }              // For light text references
    static var accent: Color { accentSuccess }               // For general accent references
    static var black: Color { Color.black }                   // For black color references
    static var orange: Color { accentNutrition }             // For orange color references
    
    // Pill colors for SelectableChip compatibility
    struct Pill {
        static var background: Color { DSColor.bgElevated }
        static var selectedBackground: Color { DSColor.accentSuccess }
        static var stroke: Color { DSColor.borderHairline }
        static var selectedStroke: Color { DSColor.accentSuccess }
        static var text: Color { DSColor.labelPrimary }
        static var selectedText: Color { Color.white }
        static var shadow: Color { DSColor.shadow }
    }
}