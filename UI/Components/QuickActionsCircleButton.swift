import SwiftUI

struct QuickActionsCircleButton: View {
    let title: String
    let systemName: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                // Circular icon background
                ZStack {
                    Circle()
                        .fill(tint.opacity(0.12))
                    Image(systemName: systemName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(tint)
                }
                .frame(width: 36, height: 36)

                // Label
                Text(title)
                    .font(.footnote)
                    .foregroundStyle(DSColor.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(title))
    }
}