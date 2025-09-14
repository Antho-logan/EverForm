import SwiftUI


extension Color {
    // CTA red for Fix Pain buttons (tweak if you already have a brand red token)
    static let efActionRed  = Color(hex: "#F2484D")
    // Risk badge colors
    static let efRiskLow    = Color(hex: "#38C172")
    static let efRiskMed    = Color(hex: "#F6C34A")
    static let efRiskHigh   = Color(hex: "#F2484D")

    // Page background fallback (prefer your theme if present)
    static var efPageBG: Color { Color(uiColor: .systemGroupedBackground) }
}