import SwiftUI

struct ProfileAvatarButton: View {
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color(hue: 0.33, saturation: 0.6, brightness: 0.75).opacity(0.2))
                Image(systemName: "person.fill")
                    .foregroundStyle(Color(hue: 0.33, saturation: 0.6, brightness: 0.75))
            }
            .frame(width: size, height: size)
        }
        .accessibilityLabel("Profile")
    }
}