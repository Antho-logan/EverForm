import SwiftUI

/// App-wide appearance selection. Keep existing cases but ensure these three exist.
enum AppAppearance: String, Codable, CaseIterable {
    case system    // our beige theme (keep current behavior)
    case light     // white/light grey theme
    case dark      // restored deep dark theme
}

/// Central theme facade returning semantic colors for the *resolved* appearance.
enum AppTheme {
    struct Palette {
        let bg: Color
        let surface: Color
        let card: Color
        let stroke: Color
        let textPrimary: Color
        let textSecondary: Color
        let control: Color
        let chartFill: Color
    }

    // MARK: - Palettes

    private static let light = Palette(
        bg: Color(hex: "#F5F5F7"),
        surface: .white,
        card: .white,
        stroke: Color(hex: "#E8EAED"),
        textPrimary: Color(hex: "#111418"),
        textSecondary: Color(hex: "#6B7280"),
        control: Color(hex: "#F3F4F6"),
        chartFill: Color(hex: "#FDE6C7")
    )

    private static let dark = Palette(
        bg: Color(hex: "#0F1114"),
        surface: Color(hex: "#13161A"),
        card: Color(hex: "#171B21"),
        stroke: Color(hex: "#222832"),
        textPrimary: Color(hex: "#E9EDF5"),
        textSecondary: Color(hex: "#A7AFBA"),
        control: Color(hex: "#1E242C"),
        chartFill: Color(hex: "#2A2F37")
    )

    // System (beige) pulls from existing design tokens to avoid regressions.
    // If you already have DSColor / DesignSystem.Colors for beige, reuse them here.
    private static let systemBeige = Palette(
        bg: DesignSystem.Colors.backgroundSecondary,   // existing beige page background
        surface: DSColor.card,                         // your existing surface/blocks
        card: DSColor.card,                            // same card look as today
        stroke: Color.black.opacity(0.08),
        textPrimary: DSColor.textPrimary,
        textSecondary: DSColor.textSecondary,
        control: Color.white.opacity(0.85),           // use your existing control bg
        chartFill: Color(hex: "#F8E6CB")              // fallback to beige chart fill
    )

    // MARK: - Resolve

    static func palette(for colorScheme: ColorScheme, appearance: AppAppearance) -> Palette {
        switch appearance {
        case .system: return systemBeige
        case .light:  return light
        case .dark:   return dark
        }
    }

    static func bg(for cs: ColorScheme, _ appearance: AppAppearance) -> Color {
        palette(for: cs, appearance: appearance).bg
    }
    static func surface(for cs: ColorScheme, _ appearance: AppAppearance) -> Color {
        palette(for: cs, appearance: appearance).surface
    }
    static func card(for cs: ColorScheme, _ appearance: AppAppearance) -> Color {
        palette(for: cs, appearance: appearance).card
    }
    static func stroke(for cs: ColorScheme, _ appearance: AppAppearance) -> Color {
        palette(for: cs, appearance: appearance).stroke
    }
    static func textPrimary(for cs: ColorScheme, _ appearance: AppAppearance) -> Color {
        palette(for: cs, appearance: appearance).textPrimary
    }
    static func textSecondary(for cs: ColorScheme, _ appearance: AppAppearance) -> Color {
        palette(for: cs, appearance: appearance).textSecondary
    }
    static func control(for cs: ColorScheme, _ appearance: AppAppearance) -> Color {
        palette(for: cs, appearance: appearance).control
    }
    static func chartFill(for cs: ColorScheme, _ appearance: AppAppearance) -> Color {
        palette(for: cs, appearance: appearance).chartFill
    }
}

// Color hex extension already exists in EFColors+Extras.swift