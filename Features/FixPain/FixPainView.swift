//
//  FixPainView.swift
//  EverForm
//
//  Full-screen pain relief with body region selection
//

import SwiftUI

struct FixPainView: View {
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.dismiss) private var dismiss

    private let twoCols = [
        GridItem(.flexible(), spacing: EFSpacing.grid, alignment: .top),
        GridItem(.flexible(), spacing: EFSpacing.grid, alignment: .top)
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: twoCols, spacing: EFSpacing.grid) {
                FixPainCard(
                    title: "Back",
                    subtitle: "Lower or upper back",
                    systemIcon: "dumbbell.fill",
                    color: .red
                ) {
                    router.present(.painArea(PainArea.back))
                }
                FixPainCard(
                    title: "Neck",
                    subtitle: "Neck tension or stiffness",
                    systemIcon: "circle.dotted",
                    color: .teal
                ) {
                    router.present(.painArea(PainArea.neck))
                }
                FixPainCard(
                    title: "Knees",
                    subtitle: "Knee pain or soreness",
                    systemIcon: "figure.walk",
                    color: .orange
                ) {
                    router.present(.painArea(PainArea.knees))
                }
                FixPainCard(
                    title: "Shoulders",
                    subtitle: "Shoulder tension or pain",
                    systemIcon: "figure.stand",
                    color: .purple
                ) {
                    router.present(.painArea(PainArea.shoulders))
                }
                FixPainCard(
                    title: "Hips",
                    subtitle: "Hip tightness or discomfort",
                    systemIcon: "figure.cooldown",
                    color: .blue
                ) {
                    router.present(.painArea(PainArea.hips))
                }
                FixPainCard(
                    title: "Wrists",
                    subtitle: "Wrist pain or strain",
                    systemIcon: "hand.raised",
                    color: .green
                ) {
                    router.present(.painArea(PainArea.wrists))
                }
            }
            .padding(.horizontal, EFSpacing.page)
            .padding(.bottom, 24)
        }
        .scrollContentBackground(.hidden)
        .background(EFTheme.appBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button(action: { dismiss() }) {
              Image(systemName: "chevron.left")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Color.primary)
            }
            .buttonStyle(.plain)
          }
          ToolbarItem(placement: .principal) {
            Text("Fix Pain")
              .font(.system(size: 24, weight: .bold, design: .rounded))
          }
        }
    }
}

#Preview {
    FixPainView()
        .environmentObject(NavigationRouter())
}