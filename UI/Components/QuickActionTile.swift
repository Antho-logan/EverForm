import SwiftUI

// Import legacy palette for compatibility

struct QuickActionTile: View {
    let icon: String
    let title: String
    let style: SemanticStyle
    let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme
    @State private var isPressed = false

    enum SemanticStyle: String, Codable, CaseIterable {
        case success, info, danger, water

        func color(for colorScheme: ColorScheme) -> Color {
            switch self {
            case .success: return .green
            case .info: return .blue
            case .danger: return .red
            case .water: return .cyan
            }
        }
    }

    // Icon rendering differs by scheme: light = no chip, bold icon; dark = keep chip.
    @ViewBuilder
    private var iconView: some View {
        let semanticColor = style.color(for: colorScheme)

        if colorScheme == .light {
            // Pop the icon: heavier weight, slightly larger, subtle glow.
            Image(systemName: icon)
                .symbolRenderingMode(.monochrome)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(semanticColor)
                .shadow(color: semanticColor.opacity(0.15), radius: 6, x: 0, y: 2)
                .frame(width: 44, height: 44) // reserve space so tiles align with dark mode
        } else {
            // Preserve dark-mode look (chip stays as before).
            ZStack {
                Circle()
                    .fill(Color(.systemFill))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(semanticColor)
            }
        }
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                iconView

                // Title
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: 96)
            .efCard()
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3), value: isPressed)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
        }, perform: {})
        .accessibilityLabel(title)
        .accessibilityHint("Tap to \(title.lowercased())")
    }
}

#Preview {
    // Using DSColor instead of legacy Theme palette
    
    VStack(spacing: 16) {
        HStack(spacing: 12) {
            QuickActionTile(
                icon: "drop.fill",
                title: "Add Water",
                style: .water
            ) {}
            
            QuickActionTile(
                icon: "wind",
                title: "Breathwork",
                style: .success
            ) {}
        }
        
        HStack(spacing: 12) {
            QuickActionTile(
                icon: "cross.case",
                title: "Fix Pain",
                style: .danger
            ) {}
            
            QuickActionTile(
                icon: "brain.head.profile",
                title: "Ask Coach",
                style: .info
            ) {}
        }
    }
    .padding()
    .background(DSColor.bg)
}
