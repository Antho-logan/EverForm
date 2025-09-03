import SwiftUI

struct VoiceHUD: View {
    @ObservedObject var voice = EFVoiceCapture.shared
    private let barCount = 28

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<barCount, id: \.self) { i in
                let height = max(4, CGFloat(voice.level) * 36 * (i % 3 == 0 ? 1.2 : 1.0))
                Capsule()
                    .frame(width: 3, height: height)
                    .opacity(0.85)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(
            Capsule().stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .animation(.linear(duration: 0.08), value: voice.level)
        .accessibilityHidden(true)
    }
}
