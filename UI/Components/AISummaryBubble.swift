import SwiftUI

struct AISummaryBubble: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.secondary)
            Text(text)
                .font(.body)
                .foregroundStyle(.primary)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.efPageBG.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.black.opacity(0.05))
                )
                .accessibilityLabel("Coach summary: \(text)")
        }
        .padding(.horizontal, 4)
        .padding(.top, 8)
    }
}