//
//  FixPainCard.swift
//  EverForm
//
//  Reusable pain area card component matching Today's Plan styling
//

import SwiftUI

struct FixPainCard: View {
    let area: PainArea
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: EFSpacing.section) {
            // Icon and content stack (aligned left like Hips)
            HStack(alignment: .center, spacing: EFSpacing.grid) {
                // Icon circle
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Image(systemName: area.iconName)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(accentColor)
                }

                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text(area.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(DSColor.textPrimary)

                    Text(area.description)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(DSColor.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }

            Spacer(minLength: 0)

            // Start pill button (bottom-right)
            HStack {
                Spacer()
                EFPillButton(
                    title: "Start",
                    style: .tinted,
                    color: accentColor
                ) {
                    action()
                }
            }
        }
        .padding(EFSpacing.section)
        .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150)
        .background(DSColor.card)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(DSColor.borderHairline, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 8, y: 4)
        .contentShape(Rectangle())
        .onTapGesture(perform: action)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(area.rawValue) pain relief. \(area.description)")
        .accessibilityHint("Start assessment")
    }

    // Accent color mapping based on requirements
    private var accentColor: Color {
        switch area {
        case .back:
            return .red
        case .neck:
            return .teal
        case .knees:
            return .orange
        case .shoulders:
            return .purple
        case .hips:
            return .blue
        case .wrists:
            return .green
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        FixPainCard(area: .back) {
            print("Back pain assessment started")
        }

        FixPainCard(area: .shoulders) {
            print("Shoulder pain assessment started")
        }
    }
    .padding()
    .background(DSColor.bg)
}