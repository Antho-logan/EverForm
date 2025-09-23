import SwiftUI

struct PlanIcon: View {
    let systemName: String
    let tint: Color
    let size: CGFloat = 36

    var body: some View {
        ZStack {
            Circle()
                .fill(tint.opacity(0.12))
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(tint)
        }
        .frame(width: size, height: size)
    }
}