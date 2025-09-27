//
//  BreathworkView.swift
//  EverForm
//
//  Full-screen breathwork experience with modern breathing ring
//

import SwiftUI
import UIKit

struct BreathPattern: Identifiable {
    let id = UUID()
    let name: String
    let phases: [(phase: BreathPhase, seconds: Int)]
}

private let patterns: [BreathPattern] = [
    .init(name: "4-7-8", phases: [
        (.inhale, 4),
        (.hold1, 7),
        (.exhale, 8)
    ]),
    .init(name: "Box", phases: [
        (.inhale, 4),
        (.hold1, 4),
        (.exhale, 4),
        (.hold2, 4)
    ]),
    .init(name: "Deep", phases: [
        (.inhale, 6),
        (.hold1, 3),
        (.exhale, 6),
        (.hold2, 2)
    ])
]

struct BreathworkView: View {
    @State private var selectedPattern: BreathPattern = patterns.first!
    @State private var isRunning: Bool = false
    @State private var showingSession: Bool = false

    var body: some View {
        EFModalSheetScaffold(title: "Breathwork") {
            // Pattern selection
            VStack(spacing: 16) {
                ForEach(patterns) { pattern in
                    EFCard {
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(pattern.name)
                                    .font(.headline)
                                    .foregroundStyle(DSColor.textPrimary)

                                Text(patternDurationText(pattern))
                                    .font(.caption)
                                    .foregroundStyle(DSColor.textSecondary)
                            }

                            Spacer()

                            if pattern.id == selectedPattern.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(DSColor.accentSuccess)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onTapGesture {
                        selectedPattern = pattern
                    }
                }
            }

            // Start button
            Button {
                showingSession = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "wind")
                        .font(.system(size: 20, weight: .semibold))
                    Text("Start Session")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(.white)
                .background(DSColor.accentSuccess)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            // Information card
            EFCard {
                VStack(alignment: .leading, spacing: 12) {
                    Text("How It Works")
                        .font(.headline)
                        .foregroundStyle(DSColor.textPrimary)

                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(icon: "lungs.fill", title: "Inhale", description: "Breathe in slowly and deeply")
                        InfoRow(icon: "pause.fill", title: "Hold", description: "Hold your breath briefly")
                        InfoRow(icon: "wind", title: "Exhale", description: "Release slowly and completely")
                    }
                }
            }
            .padding(.top, 8)
        }
        .sheet(isPresented: $showingSession) {
            BreathworkSessionView(
                pattern: selectedPattern,
                isRunning: $showingSession
            )
            .presentationBackground(EFTheme.appBackground)
            .presentationDetents([.large])
            .presentationCornerRadius(28)
            .interactiveDismissDisabled(false)
            .presentationDragIndicator(.hidden)
        }
    }

    private func patternDurationText(_ pattern: BreathPattern) -> String {
        let totalSeconds = pattern.phases.reduce(0) { $0 + $1.seconds }
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return minutes > 0 ? "\(minutes)m \(seconds)s" : "\(seconds)s per cycle"
    }
}

private struct InfoRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(DSColor.accentSuccess)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(DSColor.textPrimary)

                Text(description)
                    .font(.caption)
                    .foregroundStyle(DSColor.textSecondary)
            }

            Spacer()
        }
    }
}

#Preview {
    BreathworkView()
}