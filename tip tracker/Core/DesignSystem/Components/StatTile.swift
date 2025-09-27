// EFStatCardView.swift
import SwiftUI

// MARK: - Stat Card View (matches Today's Plan card styling)
public struct EFStatCardView: View {
    let icon: String
    let iconTint: Color
    let title: String
    let value: String
    let subtitle: String

    public init(icon: String, iconTint: Color, title: String, value: String, subtitle: String) {
        self.icon = icon
        self.iconTint = iconTint
        self.title = title
        self.value = value
        self.subtitle = subtitle
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Icon with circular background
            ZStack {
                Circle()
                    .fill(iconTint.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(iconTint)
            }

            // Value (large text)
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(DSColor.textPrimary)

            // Title (subtitle)
            Text(title.uppercased())
                .font(.system(size: 13, weight: .semibold))
                .tracking(0.5)
                .foregroundStyle(DSColor.textSecondary)
        }
        .frame(maxWidth: .infinity, minHeight: 132, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(DSColor.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(DSColor.borderHairline.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, y: 4)
    }
}

// MARK: - Helper Extensions (Private)
private extension Color {
    static var borderHairline: Color { DSColor.borderHairline }
}

