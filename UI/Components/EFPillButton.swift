//
//  EFPillButton.swift
//  EverForm
//
//  Pill-style button component
//

import SwiftUI

struct EFPillButton: View {
    let title: String
    let style: Style
    let color: Color?
    let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    enum Style {
        case primary, secondary, tinted
    }

    init(title: String, style: Style, color: Color? = nil, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.color = color
        self.action = action
    }

    var body: some View {
        let palette = Theme.palette(colorScheme)
        let buttonColor = color ?? palette.accent

        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(foregroundColor(for: buttonColor))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(backgroundColor(for: buttonColor))
                .clipShape(RoundedRectangle(cornerRadius: Radius.pill))
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.pill)
                        .stroke(strokeColor(for: buttonColor), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private func foregroundColor(for buttonColor: Color) -> Color {
        switch style {
        case .primary:
            return .white
        case .secondary, .tinted:
            return buttonColor
        }
    }

    private func backgroundColor(for buttonColor: Color) -> Color {
        switch style {
        case .primary:
            return buttonColor
        case .secondary:
            return buttonColor.opacity(0.1)
        case .tinted:
            return buttonColor.opacity(0.08)
        }
    }

    private func strokeColor(for buttonColor: Color) -> Color {
        switch style {
        case .primary:
            return Color.clear
        case .secondary:
            return buttonColor
        case .tinted:
            return buttonColor.opacity(0.2)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        EFPillButton(title: "Primary Button", style: .primary) {
            print("Primary tapped")
        }

        EFPillButton(title: "Secondary Button", style: .secondary) {
            print("Secondary tapped")
        }

        EFPillButton(title: "Tinted Button", style: .tinted) {
            print("Tinted tapped")
        }

        EFPillButton(title: "Green Tinted", style: .tinted, color: .green) {
            print("Green tinted tapped")
        }
    }
    .padding()
}
