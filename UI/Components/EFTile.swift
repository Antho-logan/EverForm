import SwiftUI

public struct EFTile: View {
    @Environment(\.colorScheme) private var scheme
    let icon: String
    let title: String
    let value: String?
    let action: () -> Void
    
    @State private var isPressed = false
    
    public init(icon: String, title: String, value: String? = nil, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.value = value
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            VStack(spacing: DesignSystem.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(DSColor.accentSuccess.opacity(0.15))
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(DSColor.accentSuccess)
                }
                
                VStack(spacing: 2) {
                    if let value = value {
                        Text(value)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(DSColor.labelPrimary)
                    }
                    
                    Text(title.uppercased())
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(DSColor.labelSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(minWidth: 56, minHeight: 56)
            .padding(DesignSystem.Spacing.md)
            .background(DSColor.bgElevated)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.Radius.lg)
                    .stroke(DSColor.borderHairline, lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignSystem.Radius.lg))
            .shadow(
                color: DSColor.shadow,
                radius: 8,
                x: 0,
                y: 4
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .opacity(isPressed ? 0.8 : 1.0)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
        }, perform: {})
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title): \(value ?? "")")
        .accessibilityAddTraits(.isButton)
        .frame(minWidth: 44, minHeight: 44)
    }
}

#Preview {
    HStack {
        EFTile(icon: "figure.walk", title: "Steps", value: "8,234") {}
        EFTile(icon: "flame.fill", title: "Calories", value: "1,456") {}
        EFTile(icon: "bed.double.fill", title: "Sleep", value: "7h 32m") {}
        EFTile(icon: "drop.fill", title: "Water", value: "6 cups") {}
    }
    .padding()
    .background(DSColor.bg)
}
