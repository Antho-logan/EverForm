//
//  FixPainSheetView.swift
//  EverForm
//
//  Bottom sheet for pain area selection matching Overview styling
//

import SwiftUI

struct FixPainSheetView: View {
    // Inject the app's router the same way Overview uses it
    @EnvironmentObject private var router: NavigationRouter

    private let twoCols = [
        GridItem(.flexible(), spacing: EFSpacing.grid, alignment: .top),
        GridItem(.flexible(), spacing: EFSpacing.grid, alignment: .top)
    ]

    var body: some View {
        EFModalSheetScaffold(title: "Fix Pain") {
            // 2-column grid of pain area cards
            LazyVGrid(columns: twoCols, spacing: EFSpacing.grid) {
                        planCard(
                            title: "Back",
                            subtitle: "Lower or upper back",
                            systemIcon: "dumbbell.fill",
                            color: .red
                        ) {
                            router.present(.painArea(PainArea.back))
                        }

                        planCard(
                            title: "Neck",
                            subtitle: "Neck tension or stiffness",
                            systemIcon: "circle.dotted",
                            color: .teal
                        ) {
                            router.present(.painArea(PainArea.neck))
                        }

                        planCard(
                            title: "Knees",
                            subtitle: "Knee pain or soreness",
                            systemIcon: "figure.walk",
                            color: .orange
                        ) {
                            router.present(.painArea(PainArea.knees))
                        }

                        planCard(
                            title: "Shoulders",
                            subtitle: "Shoulder tension or pain",
                            systemIcon: "figure.stand",
                            color: .purple
                        ) {
                            router.present(.painArea(PainArea.shoulders))
                        }

                        planCard(
                            title: "Hips",
                            subtitle: "Hip tightness or discomfort",
                            systemIcon: "figure.cooldown",
                            color: .blue
                        ) {
                            router.present(.painArea(PainArea.hips))
                        }

                        planCard(
                            title: "Wrists",
                            subtitle: "Wrist pain or strain",
                            systemIcon: "hand.raised",
                            color: .green
                        ) {
                            router.present(.painArea(PainArea.wrists))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
            }

    private func planCard(title: String, subtitle: String, systemIcon: String, color: Color, action: @escaping () -> Void) -> some View {
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
    FixPainSheetView()
        .environmentObject(NavigationRouter())
        .presentationDetents([.large])
        .presentationCornerRadius(28)
        .presentationDragIndicator(.hidden)
        .interactiveDismissDisabled(false)
        .presentationBackground(DSColor.bg)
}
