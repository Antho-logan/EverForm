//
//  FixPainCard.swift
//  EverForm
//
//  Reusable pain area card component matching Today's Plan styling
//

import SwiftUI

struct FixPainCard: View {
    let title: String
    let subtitle: String
    let systemIcon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            EFCard {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        PlanIcon(systemName: systemIcon, tint: color)
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(DSColor.textPrimary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.9)
                    }
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(DSColor.textSecondary)
                        .lineLimit(1)
                    HStack {
                        Spacer()
                        Text("Start")
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(color)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(color.opacity(0.12), in: Capsule())
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 16) {
        FixPainCard(
            title: "Back",
            subtitle: "Lower or upper back",
            systemIcon: "dumbbell.fill",
            color: .red
        ) {
            print("Back card tapped")
        }

        FixPainCard(
            title: "Shoulders",
            subtitle: "Shoulder tension or pain",
            systemIcon: "figure.stand",
            color: .purple
        ) {
            print("Shoulders card tapped")
        }
    }
    .padding()
    .background(DSColor.bg)
}