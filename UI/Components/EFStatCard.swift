import SwiftUI

struct EFStatCard: View {
    var icon: String
    var tint: Color
    var value: String
    var label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(tint.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(tint)
            }

            // Value
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.primary)

            // Label
            Text(label.uppercased())
                .font(.system(size: 13, weight: .semibold))
                .tracking(0.5)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 132, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(DSColor.card)
        )
        .overlay(
            // subtle hairline to match other cards if used in the app
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.black.opacity(0.06), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, y: 4)
    }
}
