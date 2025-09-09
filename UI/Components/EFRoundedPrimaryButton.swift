import SwiftUI

struct EFRoundedPrimaryButton: ButtonStyle {
    var fill: Color = .accentColor
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .frame(maxWidth: .infinity, minHeight: 56)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(fill.opacity(configuration.isPressed ? 0.85 : 1))
            )
            .foregroundStyle(Color.white)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}