import SwiftUI

struct StartPill: View {
    var title: String = "Start"
    var tint: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)      // small, like Today's Plan
        .tint(tint)
        .clipShape(Capsule())
    }
}