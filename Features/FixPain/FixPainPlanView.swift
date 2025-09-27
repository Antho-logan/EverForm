//
//  FixPainPlanView.swift
//  EverForm
//
//  Pain assessment result and relief plan view
//

import SwiftUI

// MARK: - Local theme + nav bar helpers (file-scoped)
fileprivate enum AppThemeUIV2 {
    static let canvas: Color = DesignSystem.Colors.backgroundSecondary
    static let ctaNutrition: Color = DSColor.accentNutrition
    static let ctaPain: Color = EFColor.painAccent
    static let riskLow: Color = .green
    static let riskMed: Color = .orange
    static let riskHigh: Color = .red
}


fileprivate extension View {
    /// Apply themed canvas bg and visible toolbar background
    func applyAppPageChromeUIV2() -> some View {
        self
            .background(DSColor.bg.ignoresSafeArea())
            .toolbarBackground(DSColor.barBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}


struct FixPainPlanView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var assessment = PainAssessment(area: .back)
    let onStartPlan: (Bool) -> Void
    
    @State private var showingStartConfirmation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with classification
                    headerSection

                    // Plan blocks
                    planBlocksSection

                    // Medical disclaimer
                    medicalDisclaimer
                }
                .padding(.horizontal, PainUI.Layout.hPadding)
                .padding(.vertical, PainUI.Layout.vSpacing)
            }
            .applyAppPageChromeUIV2()
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert("Start Relief Plan", isPresented: $showingStartConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Start Plan") {
                startPlan()
            }
        } message: {
            Text("This will save your personalized relief plan and track your progress. Continue?")
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 0)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Your Pain Relief Plan")
                .font(.title.bold())
                .foregroundStyle(PainUI.Theme.textPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
            
            Text(assessment.area.rawValue)
                .font(.title3.weight(.semibold))
                .foregroundStyle(PainUI.Theme.brand)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(PainUI.Theme.card)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }
    
      
      
    // MARK: - Plan Blocks Section
    private var planBlocksSection: some View {
        VStack(spacing: 16) {
            Text("Your Relief Plan")
                .font(.title2.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
        
    // MARK: - Medical Disclaimer
    private var medicalDisclaimer: some View {
        VStack(spacing: 8) {
            Text("⚕️ Medical Disclaimer")
                .font(.caption.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textSecondary)
            
            Text("This is general information, not a medical diagnosis. If symptoms persist or worsen, consult a healthcare professional.")
                .font(.caption)
                .foregroundStyle(PainUI.Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(DSColor.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(DSColor.textSecondary.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
        
    // MARK: - Actions
    private func startPlan() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        // Show success feedback
        let success = UINotificationFeedbackGenerator()
        success.notificationOccurred(.success)

        // Dismiss with success
        onStartPlan(true)
    }
}

#Preview {
    FixPainPlanView { _ in }
}