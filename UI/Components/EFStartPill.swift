import SwiftUI

struct EFStartPill: View {
    var title: String = "Start"
    var tint: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding(.horizontal, 14)
                .frame(height: 34)
        }
        .buttonStyle(.plain)
        .background(tint.opacity(0.12), in: Capsule())
        .overlay(Capsule().stroke(tint.opacity(0.28)))
        .foregroundStyle(tint)
        .accessibilityLabel(title)
    }
}