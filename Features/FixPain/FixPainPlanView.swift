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
    let result: PainAssessmentResult
    let onStartPlan: (Bool) -> Void
    
    @State private var showingStartConfirmation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with classification
                    headerSection
                    
                    // Red flag warning if present
                    if result.hasRedFlags {
                        redFlagWarning
                    }
                    
                    // Risk level indicator
                    riskLevelSection
                    
                    // Plan blocks
                    planBlocksSection
                    
                    // AI Summary
                    aiSummarySection
                    
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
            
            Text(result.assessment.area.rawValue)
                .font(.title3.weight(.semibold))
                .foregroundStyle(PainUI.Theme.brand)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
            
            Text(result.classification)
                .font(.subheadline)
                .foregroundStyle(PainUI.Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(PainUI.Theme.card)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }
    
    // MARK: - Red Flag Warning
    private var redFlagWarning: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title2)
                    .foregroundStyle(PainUI.Theme.actionRed)
                
                Text("⚠️ Red Flags Detected")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(PainUI.Theme.actionRed)
                
                Spacer()
            }
            
            Text("Potential red flags detected. Seek medical care.")
                .font(.subheadline)
                .foregroundStyle(PainUI.Theme.textPrimary)
            
            if !result.assessment.redFlags.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(result.assessment.redFlags) { flag in
                        HStack {
                            Text("• \(flag.rawValue)")
                                .font(.caption)
                                .foregroundStyle(PainUI.Theme.textSecondary)
                            Spacer()
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red, lineWidth: 2)
                )
        )
    }
    
    // MARK: - Risk Level Section
    private var riskLevelSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Risk Level")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(PainUI.Theme.textPrimary)
                
                Spacer()
                
                PainUI.RiskLevelBadge(level: riskBadgeLevel)
            }
            
            Text(riskLevelDescription)
                .font(.subheadline)
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
    
    // MARK: - Plan Blocks Section
    private var planBlocksSection: some View {
        VStack(spacing: 16) {
            Text("Your Relief Plan")
                .font(.title2.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(result.suggestedBlocks) { block in
                PlanBlockView(block: block, riskLevel: result.riskLevel)
            }
        }
    }
    
    // MARK: - AI Summary Section
    private var aiSummarySection: some View {
        let aiPlaceholder = computedSummaryText ?? "Based on your answers, this most likely resembles an acute strain. Keep activity light, avoid painful end-range, and follow today's plan. Seek care if pain escalates or neurological symptoms occur."
        
        return AISummaryBubble(text: aiPlaceholder)
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
    
    // MARK: - Helper Properties
    private var riskBadgeLevel: PainUI.RiskLevelBadge.PainSeverity {
        switch result.riskLevel {
        case .low: return .low
        case .moderate: return .medium
        case .high: return .high
        }
    }
    
    private var riskLevelColor: Color {
        switch result.riskLevel {
        case .low: return AppThemeUIV2.riskLow
        case .moderate: return AppThemeUIV2.riskMed
        case .high: return AppThemeUIV2.riskHigh
        }
    }
    
    private var computedSummaryText: String? {
        // This would normally come from an AI/LLM service
        // For now, return nil to use the placeholder
        return nil
    }
    
    private var riskLevelDescription: String {
        switch result.riskLevel {
        case .low:
            return "Low risk condition suitable for self-management with these exercises and strategies."
        case .moderate:
            return "Moderate risk. Monitor symptoms closely and consider professional evaluation if not improving."
        case .high:
            return "High risk. Medical evaluation recommended before starting this plan."
        }
    }
    
    // MARK: - Actions
    private func startPlan() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Save the plan
        savePlan()
        
        // Show success feedback
        let success = UINotificationFeedbackGenerator()
        success.notificationOccurred(.success)
        
        // Dismiss with success
        onStartPlan(true)
    }
    
    private func savePlan() {
        PainAssessmentStore.shared.saveAssessment(result)
    }
}

// MARK: - Plan Block View
struct PlanBlockView: View {
    @Environment(\.colorScheme) private var colorScheme
    let block: PlanBlock
    let riskLevel: RiskLevel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(block.title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(PainUI.Theme.textPrimary)
                    
                    Text(block.description)
                        .font(.caption)
                        .foregroundStyle(PainUI.Theme.textSecondary)
                }
                
                Spacer()
                
                if block.isUrgent {
                    Image(systemName: "clock.fill")
                        .font(.caption)
                        .foregroundStyle(PainUI.Theme.actionRed)
                }
            }
            
            VStack(spacing: 12) {
                ForEach(block.activities) { activity in
                    ActivityRow(activity: activity)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(DSColor.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(block.isUrgent ? 
                               Color.red.opacity(0.3) : 
                               DSColor.textSecondary.opacity(0.2), 
                               lineWidth: block.isUrgent ? 2 : 1)
                )
        )
    }
}

// MARK: - Activity Row
struct ActivityRow: View {
    @Environment(\.colorScheme) private var colorScheme
    let activity: PlanActivity
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconForActivityType(activity.type))
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(accentColorForActivityType(activity.type))
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(accentColorForActivityType(activity.type).opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(activity.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(PainUI.Theme.textPrimary)
                    
                    if let duration = activity.duration {
                        Text("• \(duration)")
                            .font(.caption)
                            .foregroundStyle(PainUI.Theme.textSecondary)
                    }
                }
                
                Text(activity.description)
                    .font(.caption)
                    .foregroundStyle(PainUI.Theme.textSecondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
    }
    
    private func iconForActivityType(_ type: ActivityType) -> String {
        switch type {
        case .breathing: return "wind"
        case .mobility: return "figure.walk"
        case .stability: return "dumbbell"
        case .posture: return "figure.stand"
        case .rest: return "bed.double"
        case .heat: return "flame"
        case .ice: return "snowflake"
        case .stretching: return "figure.strengthtraining.traditional"
        }
    }
    
    private func accentColorForActivityType(_ type: ActivityType) -> Color {
        switch type {
        case .stability, .stretching:
            return PainUI.Theme.accentTraining  // Green for training/strength
        case .heat:
            return PainUI.Theme.accentNutrition // Orange for heat/thermal
        case .rest, .ice:
            return PainUI.Theme.accentRecovery  // Blue for recovery/cold
        case .mobility, .posture:
            return PainUI.Theme.accentMobility  // Purple for mobility/flexibility
        case .breathing:
            return PainUI.Theme.accentTraining  // Green for breathing exercises
        }
    }
}

#Preview {
    let assessment = PainAssessment(area: .back, date: Date())
    let result = PainReasoner.generateResult(from: assessment)
    
    FixPainPlanView(result: result) { _ in }
}