import SwiftUI

extension Color {
    init(hex: String, alpha: Double = 1.0) {
        let s = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        let r, g, b: UInt64
        switch s.count {
        case 3: (r, g, b) = ((v >> 8) * 17, (v >> 4 & 0xF) * 17, (v & 0xF) * 17)
        default: (r, g, b) = (v >> 16, v >> 8 & 0xFF, v & 0xFF)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: alpha)
    }
}

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