import SwiftUI

struct RiskBadge: View {
    enum Level: String { case low = "Low", medium = "Medium", high = "High" }
    let level: Level

    private var colors: (bg: Color, fg: Color) {
        switch level {
        case .low:    return (Color.efRiskLow.opacity(0.15),  Color.efRiskLow)
        case .medium: return (Color.efRiskMed.opacity(0.18),  Color.efRiskMed)
        case .high:   return (Color.efRiskHigh.opacity(0.15), Color.efRiskHigh)
        }
    }

    var body: some View {
        Text(level.rawValue)
            .font(.system(size: 13, weight: .semibold))
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .foregroundStyle(colors.fg)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(colors.bg))
            .accessibilityLabel("Risk level \(level.rawValue)")
    }
}