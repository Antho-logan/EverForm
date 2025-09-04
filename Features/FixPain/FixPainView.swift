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
    @State private var showingDetail = false
    
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
            case .neck: return "head.profile"
            case .knees: return "figure.walk"
            case .shoulders: return "figure.arms.open"
            case .hips: return "figure.flexibility"
            case .wrists: return "hand.raised"
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
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Fix Pain")
                    .font(.largeTitle.bold())
                    .foregroundStyle(DSColor.textPrimary)

                Text("Select the area where you're experiencing discomfort")
                    .font(.subheadline)
                    .foregroundStyle(DSColor.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top)

            // Body region grid
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(PainRegion.allCases, id: \.self) { region in
                    PainTile(
                        title: region.rawValue,
                        subtitle: region.description,
                        symbol: region.icon,
                        isSelected: selectedRegion == region
                    ) {
                        selectedRegion = region
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                    }
                }
            }

            Spacer()

            // Continue button
            if let selectedRegion = selectedRegion {
                Button(action: {
                    showingDetail = true
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                }) {
                    Text("Get Relief Plan")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding()
        .background(DSColor.appBackground.ignoresSafeArea())
        .navigationTitle("Fix Pain")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PainTile: View {
    @Environment(\.colorScheme) private var scheme
    let title: String
    let subtitle: String
    let symbol: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: symbol)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.red)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(DSColor.textPrimary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(DSColor.textSecondary)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
            .background(DSColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: .black.opacity(scheme == .light ? 0.06 : 0), radius: 10, y: 6)
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isSelected ? Color.red : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FixPainView()
}
