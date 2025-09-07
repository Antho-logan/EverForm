//
//  FixPainView.swift
//  EverForm
//
//  Full-screen pain relief with body region selection
//

import SwiftUI

struct FixPainView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedRegion: PainRegion?
    @State private var showingAssessment = false
    @State private var toastText: String?
    
    enum PainRegion: String, CaseIterable {
        case back = "Back"
        case neck = "Neck"
        case knees = "Knees"
        case shoulders = "Shoulders"
        case hips = "Hips"
        case wrists = "Wrists"
        
        var icon: String {
            switch self {
            case .back: return "figure.stand"
            case .knees: return "figure.walk"
            case .shoulders: return "figure.arms.open"
            case .hips: return "figure.flexibility"
            case .wrists: return "hand.raised"
            case .neck: return "" // Custom icon will be used
            }
        }
        
        var description: String {
            switch self {
            case .back: return "Lower or upper back discomfort"
            case .neck: return "Neck tension or stiffness"
            case .knees: return "Knee pain or soreness"
            case .shoulders: return "Shoulder tension or pain"
            case .hips: return "Hip tightness or discomfort"
            case .wrists: return "Wrist pain or strain"
            }
        }
        
        var usesCustomIcon: Bool {
            return self == .neck
        }
    }
    
    var body: some View {
        VStack(spacing: PainUI.Layout.vSpacing) {
            // Header
            VStack(spacing: 8) {
                Text("Fix Pain")
                    .font(.largeTitle.bold())
                    .foregroundStyle(PainUI.Theme.textPrimary)

                Text("Select the area where you're experiencing discomfort")
                    .font(.subheadline)
                    .foregroundStyle(PainUI.Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, PainUI.Layout.vSpacing)

            // Body region grid
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: PainUI.Layout.cardSpacing),
                GridItem(.flexible(), spacing: PainUI.Layout.cardSpacing)
            ], spacing: PainUI.Layout.cardSpacing) {
                ForEach(PainRegion.allCases, id: \.self) { region in
                    PainTile(
                        title: region.rawValue,
                        subtitle: region.description,
                        symbol: region.icon,
                        isSelected: selectedRegion == region,
                        usesCustomIcon: region.usesCustomIcon
                    ) {
                        selectedRegion = region
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }
                }
            }
            .padding(.horizontal, PainUI.Layout.hPadding)

            Spacer()

            // Continue button
            if selectedRegion != nil {
                Button(action: {
                    showingAssessment = true
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                }) {
                    Text("Start Assessment")
                }
                .painCTA()
                .padding(.horizontal, PainUI.Layout.hPadding)
                .padding(.bottom, 8)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.top, PainUI.Layout.vSpacing)
        .background(PainUI.Theme.appBackground.ignoresSafeArea())
        .navigationTitle("Fix Pain")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(PainUI.Theme.appBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .scrollContentBackground(.hidden)
        .sheet(isPresented: $showingAssessment) {
            if let selectedRegion = selectedRegion {
                FixPainAssessmentView(area: convertToPainArea(selectedRegion)) { shouldShowToast in
                    if shouldShowToast {
                        toastText = "Relief plan saved"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { toastText = nil }
                    }
                    showingAssessment = false
                }
            }
        }
        .overlay(alignment: .bottom) {
            if let toastText = toastText {
                Text(toastText)
                    .font(.subheadline).bold()
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.bottom, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
    private func convertToPainArea(_ region: PainRegion) -> PainArea {
        switch region {
        case .back: return .back
        case .neck: return .neck
        case .knees: return .knees
        case .shoulders: return .shoulders
        case .hips: return .hips
        case .wrists: return .wrists
        }
    }
}

struct PainTile: View {
    @Environment(\.colorScheme) private var scheme
    let title: String
    let subtitle: String
    let symbol: String
    let isSelected: Bool
    let usesCustomIcon: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                iconView
                    .frame(width: 32, height: 32)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSelected ? .white : PainUI.Theme.textPrimary)
                    .fixedSize()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(isSelected ? .white : PainUI.Theme.textPrimary)
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(isSelected ? .white.opacity(0.8) : PainUI.Theme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(minHeight: 100, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: PainUI.Layout.cardCornerRadius, style: .continuous)
                    .fill(isSelected ? PainUI.Theme.brand : PainUI.Theme.card)
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    @ViewBuilder
    private var iconView: some View {
        if usesCustomIcon {
            PainGlyph {
                NeckPainIcon()
            }
        } else {
            PainGlyph {
                Image(systemName: symbol)
            }
        }
    }
}

#Preview {
    FixPainView()
}
