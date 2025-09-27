//
//  FixPainAssessmentView.swift
//  EverForm
//
//  Simplified pain assessment wizard
//

import SwiftUI

struct FixPainAssessmentView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var assessment: PainAssessment
    let onComplete: (Bool) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                headerSection

                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        assessmentContent
                    }
                    .padding(.horizontal, PainUI.Layout.hPadding)
                    .padding(.top, PainUI.Layout.vSpacing)
                }

                // Navigation buttons
                navigationButtons
            }
            .background(PainUI.Theme.appBackground.ignoresSafeArea(edges: .bottom))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(PainUI.Theme.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .scrollContentBackground(.hidden)
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Pain Assessment")
                .font(.title2.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)

            Text(assessment.area.rawValue)
                .font(.subheadline)
                .foregroundStyle(PainUI.Theme.textSecondary)
        }
        .padding(.horizontal, PainUI.Layout.hPadding)
        .padding(.vertical, PainUI.Layout.vSpacing)
        .background(PainUI.Theme.card)
    }

    // MARK: - Assessment Content
    private var assessmentContent: some View {
        VStack(spacing: 20) {
            Text("Basic Assessment")
                .font(.title3.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)

            Text("Area: \(assessment.area.rawValue)")
                .font(.body)
                .foregroundStyle(PainUI.Theme.textSecondary)

            Text("Date: \(assessment.createdAt.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption)
                .foregroundStyle(PainUI.Theme.textSecondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(PainUI.Theme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: PainUI.Layout.cardCornerRadius)
                        .stroke(PainUI.Theme.textSecondary.opacity(0.2), lineWidth: 1)
                )
        )
    }

    // MARK: - Navigation Buttons
    private var navigationButtons: some View {
        VStack(spacing: 12) {
            Button("Complete Assessment") {
                completeAssessment()
            }
            .painCTA()
        }
        .padding(.horizontal, PainUI.Layout.hPadding)
        .padding(.bottom, 8)
        .background(PainUI.Theme.appBackground.ignoresSafeArea(edges: .bottom))
    }

    // MARK: - Actions
    private func completeAssessment() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        // Show success feedback
        let success = UINotificationFeedbackGenerator()
        success.notificationOccurred(.success)

        // Complete with success
        onComplete(true)
        dismiss()
    }
}

#Preview {
    @Previewable @State var assessment = PainAssessment(area: .back)
    return FixPainAssessmentView(assessment: $assessment) { _ in }
}