// EFStatCardView.swift
import SwiftUI

// MARK: - Styles
public enum StatKind { case steps, calories, sleep, hydration }

public struct StatCardStyle {
    let background: Color
    let iconTint: Color
    let labelTint: Color

    static func forKind(_ kind: StatKind) -> StatCardStyle {
        switch kind {
        case .steps:
            return .init(
                background: DSColor.accentSuccess.opacity(0.10),   // soft mint/green
                iconTint: DSColor.accentSuccess.opacity(0.75),
                labelTint: Color.gray.opacity(0.9)
            )
        case .calories:
            return .init(
                background: DSColor.accentNutrition.opacity(0.10),  // soft orange
                iconTint: DSColor.accentNutrition.opacity(0.75),
                labelTint: Color.gray.opacity(0.9)
            )
        case .sleep:
            return .init(
                background: DSColor.accentRecovery.opacity(0.10),    // soft blue
                iconTint: DSColor.accentRecovery.opacity(0.75),
                labelTint: Color.gray.opacity(0.9)
            )
        case .hydration:
            return .init(
                background: DSColor.accentMobility.opacity(0.10),  // soft purple
                iconTint: DSColor.accentMobility.opacity(0.75),
                labelTint: Color.gray.opacity(0.9)
            )
        }
    }
}

// MARK: - Stat Card View (matches Today's Plan card styling)
public struct EFStatCardView: View {
    let icon: String
    let iconTint: Color
    let title: String
    let value: String
    let subtitle: String
    let kind: StatKind
    var style: StatCardStyle? = nil   // default preserves previous behavior

    public init(icon: String, iconTint: Color, title: String, value: String, subtitle: String, kind: StatKind, style: StatCardStyle? = nil) {
        self.icon = icon
        self.iconTint = iconTint
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.kind = kind
        self.style = style
    }

    @ViewBuilder
    private var valueView: some View {
        switch kind {
        case .calories:
            // One-line value: "current / target"
            Text("\(value)")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(DSColor.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .allowsTightening(true)
                .truncationMode(.tail)
                .layoutPriority(1)

        default:
            // Existing rendering for other kinds (Steps, Sleep, Hydration)
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(DSColor.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .allowsTightening(true)
                .layoutPriority(1)
        }
    }

    public var body: some View {
        let bg = DSColor.card                              // use standard card background
        let iconTint = style?.iconTint ?? self.iconTint
        let labelTint = style?.labelTint ?? DSColor.textSecondary

        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous) // keep existing radius
                .fill(bg) // <- use the metric background
                .shadow(color: Color.black.opacity(0.04), radius: 10, y: 6)

            // existing content...
            HStack(alignment: .top, spacing: 12) {
                // Icon bubble (tinted)
                Circle()
                    .fill(iconTint.opacity(0.2))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(iconTint)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    valueView
                    Text(title.uppercased())
                        .font(.system(size: 13, weight: .semibold))
                        .tracking(0.5)
                        .foregroundColor(labelTint)
                }
                Spacer()
            }
            .padding(16)
        }
    }
}

// MARK: - Helper Extensions (Private)
private extension Color {
    static var borderHairline: Color { DSColor.borderHairline }
}

