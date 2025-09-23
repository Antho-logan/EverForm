//
//  PainTile.swift
//  EverForm
//
//  Pain area tile component matching Today's Plan styling
//

import SwiftUI

struct PainTile: View {
    let title: String
    let subtitle: String
    let symbol: String
    let accent: Color
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: EFSpacing.section) {
            // Icon and content
            HStack(alignment: .center, spacing: EFSpacing.grid) {
                // Icon circle
                ZStack {
                    Circle()
                        .fill(accent.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Image(systemName: symbol)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(accent)
                }

                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(DSColor.textPrimary)

                    Text(subtitle)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(DSColor.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }

            // Start pill button
            EFPillButton(
                title: "Start",
                style: .secondary,
                color: accent
            ) {
                action()
            }
        }
        .padding(EFSpacing.section)
        .background(DSColor.card)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(DSColor.borderHairline, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 8, y: 4)
    }
}

#Preview {
    VStack(spacing: 16) {
        PainTile(
            title: "Back",
            subtitle: "Lower or upper back discomfort",
            symbol: "figure.stand",
            accent: .orange
        ) {
            print("Back tile tapped")
        }

        PainTile(
            title: "Knees",
            subtitle: "Knee pain or soreness",
            symbol: "figure.walk",
            accent: .blue
        ) {
            print("Knees tile tapped")
        }
    }
    .padding()
    .background(DSColor.bg)
}