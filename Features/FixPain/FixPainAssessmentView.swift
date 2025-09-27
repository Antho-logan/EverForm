//
//  FixPainAssessmentView.swift
//  EverForm
//
//  Multi-step pain assessment wizard
//

import SwiftUI

struct FixPainAssessmentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var assessment: PainAssessment
    @State private var showPlanView = false
    @State private var planResult: PainAssessmentResult?

    let area: PainArea
    let onComplete: (Bool) -> Void
    
    private let totalSteps = 10
    
    init(area: PainArea, onComplete: @escaping (Bool) -> Void) {
        self.area = area
        self.onComplete = onComplete
        self._assessment = State(initialValue: PainAssessment(area: area))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress header
                progressHeader
                
                // Step content
                ScrollView {
                    VStack(spacing: 24) {
                        currentStepContent
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))
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
            .animation(.easeInOut(duration: 0.3), value: currentStep)
        }
        .sheet(isPresented: $showPlanView) {
            if let result = planResult {
                FixPainPlanView(result: result) { shouldDismiss in
                    if shouldDismiss {
                        onComplete(true)
                        dismiss()
                    }
                    showPlanView = false
                }
            }
        }
    }
    
    // MARK: - Progress Header
    private var progressHeader: some View {
        VStack(spacing: 8) {
            Text("Step \(currentStep + 1) of \(totalSteps)")
                .font(.caption.weight(.medium))
                .foregroundStyle(PainUI.Theme.textSecondary)
            
            PainUI.StepProgressBar(currentStep: currentStep, totalSteps: totalSteps)
        }
        .padding(.horizontal, PainUI.Layout.hPadding)
        .padding(.vertical, PainUI.Layout.vSpacing)
        .background(PainUI.Theme.card)
    }
    
    // MARK: - Step Content
    @ViewBuilder
    private var currentStepContent: some View {
        switch currentStep {
        case 0:
            StepLocationDetail(assessment: $assessment)
        case 1:
            StepSeverity(assessment: $assessment)
        case 2:
            StepOnsetDuration(assessment: $assessment)
        case 3:
            StepPainQuality(assessment: $assessment)
        case 4:
            StepSymptoms(assessment: $assessment)
        case 5:
            StepAggravatingFactors(assessment: $assessment)
        case 6:
            StepRelievingFactors(assessment: $assessment)
        case 7:
            StepFunctionalImpact(assessment: $assessment)
        case 8:
            StepRedFlags(assessment: $assessment)
        case 9:
            StepNotes(assessment: $assessment)
        default:
            EmptyView()
        }
    }
    
    // MARK: - Navigation Buttons
    private var navigationButtons: some View {
        VStack(spacing: 12) {
            Button(currentStep == totalSteps - 1 ? "Generate Plan" : "Next") {
                if currentStep == totalSteps - 1 {
                    generatePlan()
                } else {
                    withAnimation {
                        currentStep += 1
                    }
                }
            }
            .painCTA()
        }
        .padding(.horizontal, PainUI.Layout.hPadding)
        .padding(.bottom, 8)
        .background(PainUI.Theme.appBackground.ignoresSafeArea(edges: .bottom))
    }
    
    // MARK: - Plan Generation
    private func generatePlan() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        let result = PainReasoner.generateResult(from: assessment)
        planResult = result
        
        // Save to local storage
        saveAssessment(result)
        
        // Show plan view
        showPlanView = true
    }
    
    private func saveAssessment(_ result: PainAssessmentResult) {
        PainAssessmentStore.shared.saveAssessment(result)
    }
}

// MARK: - Step Views

struct StepLocationDetail: View {
    @Binding var assessment: PainAssessment

    var body: some View {
        VStack(spacing: 20) {
            Text("Where exactly is your \(assessment.area.rawValue.lowercased()) pain?")
                .font(.title2.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                ForEach(assessment.area.subAreas) { subArea in
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        assessment.subArea = subArea
                    }) {
                        HStack {
                            Text(subArea.name)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(PainUI.Theme.textPrimary)
                            Spacer()
                            if assessment.subArea?.id == subArea.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(PainUI.Theme.brand)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(assessment.subArea?.id == subArea.id ? 
                                      PainUI.Theme.brand.opacity(0.1) : 
                                      PainUI.Theme.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: PainUI.Layout.cardCornerRadius)
                                        .stroke(assessment.subArea?.id == subArea.id ? 
                                               PainUI.Theme.brand : 
                                               PainUI.Theme.textSecondary.opacity(0.2), 
                                               lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct StepSeverity: View {
    @Binding var assessment: PainAssessment
    @State private var tempSeverity: Double = 5
    
    var body: some View {
        VStack(spacing: 20) {
            Text("How severe is your pain?")
                .font(.title2.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)
            
            VStack(spacing: 16) {
                Text("\(Int(tempSeverity))")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(PainUI.Theme.actionRed)
                
                Slider(value: $tempSeverity, in: 0...10, step: 1)
                    .tint(PainUI.Theme.actionRed)
                
                HStack {
                    Text("No pain")
                        .font(.caption)
                        .foregroundStyle(PainUI.Theme.textSecondary)
                    Spacer()
                    Text("Worst possible")
                        .font(.caption)
                        .foregroundStyle(PainUI.Theme.textSecondary)
                }
            }
            .padding(.vertical, PainUI.Layout.vSpacing)
            .padding(.horizontal, PainUI.Layout.hPadding)
            .background(PainUI.Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: PainUI.Layout.cardCornerRadius))
        }
        .onAppear {
            tempSeverity = Double(assessment.severity)
        }
        .onChange(of: tempSeverity) { _, newValue in
            assessment.severity = Int(newValue)
        }
    }
}

struct StepOnsetDuration: View {
    @Binding var assessment: PainAssessment
    
    var body: some View {
        VStack(spacing: 20) {
            Text("When did the pain start and how long has it lasted?")
                .font(.title2.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)
            
            VStack(spacing: 16) {
                Section(header: Text("Onset").font(.headline.weight(.semibold)).foregroundStyle(PainUI.Theme.textPrimary)) {
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                        ForEach(PainOnset.allCases) { onset in
                            SelectableChip(
                                title: onset.rawValue,
                                isSelected: assessment.onset == onset
                            ) {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                assessment.onset = onset
                            }
                        }
                    }
                }
                
                Section(header: Text("Duration").font(.headline.weight(.semibold)).foregroundStyle(PainUI.Theme.textPrimary).padding(.top, 8)) {
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                        ForEach(PainDuration.allCases) { duration in
                            SelectableChip(
                                title: duration.rawValue,
                                isSelected: assessment.duration == duration
                            ) {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                assessment.duration = duration
                            }
                        }
                    }
                }
            }
        }
    }
}

struct StepPainQuality: View {
    @Binding var assessment: PainAssessment
    
    var body: some View {
        VStack(spacing: 20) {
            Text("How would you describe the pain?")
                .font(.title2.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)
            
            Text("Select all that apply:")
                .font(.subheadline)
                .foregroundStyle(PainUI.Theme.textSecondary)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                ForEach(PainQuality.allCases) { quality in
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        toggleQuality(quality)
                    }) {
                        HStack {
                            Text(quality.rawValue)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(PainUI.Theme.textPrimary)
                            Spacer()
                            if assessment.qualities.contains(quality) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(PainUI.Theme.brand)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(assessment.qualities.contains(quality) ? 
                                      Color.red.opacity(0.1) : 
                                      DSColor.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(assessment.qualities.contains(quality) ? 
                                               Color.red : 
                                               DSColor.textSecondary.opacity(0.2), 
                                               lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private func toggleQuality(_ quality: PainQuality) {
        if assessment.qualities.contains(quality) {
            assessment.qualities.removeAll { $0 == quality }
        } else {
            assessment.qualities.append(quality)
        }
    }
}

struct StepSymptoms: View {
    @Binding var assessment: PainAssessment
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Do you experience any of these symptoms?")
                .font(.title2.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)
            
            Text("Select all that apply:")
                .font(.subheadline)
                .foregroundStyle(PainUI.Theme.textSecondary)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                ForEach(PainSymptom.allCases) { symptom in
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        toggleSymptom(symptom)
                    }) {
                        HStack {
                            Text(symptom.rawValue)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(PainUI.Theme.textPrimary)
                            Spacer()
                            if assessment.symptoms.contains(symptom) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(PainUI.Theme.brand)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(assessment.symptoms.contains(symptom) ? 
                                      Color.red.opacity(0.1) : 
                                      DSColor.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(assessment.symptoms.contains(symptom) ? 
                                               Color.red : 
                                               DSColor.textSecondary.opacity(0.2), 
                                               lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private func toggleSymptom(_ symptom: PainSymptom) {
        if assessment.symptoms.contains(symptom) {
            assessment.symptoms.removeAll { $0 == symptom }
        } else {
            assessment.symptoms.append(symptom)
        }
    }
}

struct StepAggravatingFactors: View {
    @Binding var assessment: PainAssessment
    
    var body: some View {
        VStack(spacing: 20) {
            Text("What makes your pain worse?")
                .font(.title2.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)
            
            Text("Select all that apply:")
                .font(.subheadline)
                .foregroundStyle(PainUI.Theme.textSecondary)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                ForEach(assessment.area.aggravatingFactors) { factor in
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        toggleFactor(factor)
                    }) {
                        HStack {
                            Text(factor.name)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(PainUI.Theme.textPrimary)
                            Spacer()
                            if assessment.aggravatingFactors.contains(factor) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(PainUI.Theme.brand)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(assessment.aggravatingFactors.contains(factor) ? 
                                      Color.red.opacity(0.1) : 
                                      DSColor.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(assessment.aggravatingFactors.contains(factor) ? 
                                               Color.red : 
                                               DSColor.textSecondary.opacity(0.2), 
                                               lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private func toggleFactor(_ factor: PainFactor) {
        if assessment.aggravatingFactors.contains(factor) {
            assessment.aggravatingFactors.removeAll { $0 == factor }
        } else {
            assessment.aggravatingFactors.append(factor)
        }
    }
}

struct StepRelievingFactors: View {
    @Binding var assessment: PainAssessment
    
    var body: some View {
        VStack(spacing: 20) {
            Text("What helps relieve your pain?")
                .font(.title2.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)
            
            Text("Select all that apply:")
                .font(.subheadline)
                .foregroundStyle(PainUI.Theme.textSecondary)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                ForEach(PainReliefFactor.allCases) { factor in
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        toggleFactor(factor)
                    }) {
                        HStack {
                            Text(factor.rawValue)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(PainUI.Theme.textPrimary)
                            Spacer()
                            if assessment.relievingFactors.contains(factor) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(PainUI.Theme.brand)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(assessment.relievingFactors.contains(factor) ? 
                                      Color.red.opacity(0.1) : 
                                      DSColor.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(assessment.relievingFactors.contains(factor) ? 
                                               Color.red : 
                                               DSColor.textSecondary.opacity(0.2), 
                                               lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private func toggleFactor(_ factor: PainReliefFactor) {
        if assessment.relievingFactors.contains(factor) {
            assessment.relievingFactors.removeAll { $0 == factor }
        } else {
            assessment.relievingFactors.append(factor)
        }
    }
}

struct StepFunctionalImpact: View {
    @Binding var assessment: PainAssessment
    
    var body: some View {
        VStack(spacing: 20) {
            Text("How does this pain affect your daily activities?")
                .font(.title2.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                ForEach(FunctionalImpact.allCases) { impact in
                    Button(action: {
                        let impactGen = UIImpactFeedbackGenerator(style: .light)
                        impactGen.impactOccurred()
                        assessment.functionalImpact = impact
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: iconForImpact(impact))
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(assessment.functionalImpact == impact ? 
                                               PainUI.Theme.brand : 
                                               PainUI.Theme.textSecondary)
                            
                            Text(impact.rawValue)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(PainUI.Theme.textPrimary)
                                .foregroundStyle(PainUI.Theme.textPrimary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(assessment.functionalImpact == impact ? 
                                      Color.red.opacity(0.1) : 
                                      DSColor.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(assessment.functionalImpact == impact ? 
                                               Color.red : 
                                               DSColor.textSecondary.opacity(0.2), 
                                               lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private func iconForImpact(_ impact: FunctionalImpact) -> String {
        switch impact {
        case .none: return "figure.walk"
        case .light: return "figure.stand"
        case .hardToTrain: return "dumbbell"
        case .adlAffected: return "figure.roll"
        }
    }
}

struct StepRedFlags: View {
    @Binding var assessment: PainAssessment
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Important: Check any of these serious symptoms")
                .font(.title2.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)
            
            Text("These symptoms require immediate medical attention")
                .font(.subheadline)
                .foregroundStyle(PainUI.Theme.actionRed)
            
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 8) {
                ForEach(RedFlag.allCases) { flag in
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        toggleFlag(flag)
                    }) {
                        HStack {
                            Image(systemName: assessment.redFlags.contains(flag) ? 
                                  "checkmark.circle.fill" : "circle")
                                .foregroundStyle(assessment.redFlags.contains(flag) ? 
                                               PainUI.Theme.actionRed : 
                                               PainUI.Theme.textSecondary)
                            
                            Text(flag.rawValue)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(PainUI.Theme.textPrimary)
                                .foregroundStyle(PainUI.Theme.textPrimary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(assessment.redFlags.contains(flag) ? 
                                      Color.red.opacity(0.1) : 
                                      DSColor.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(assessment.redFlags.contains(flag) ? 
                                               Color.red : 
                                               DSColor.textSecondary.opacity(0.2), 
                                               lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private func toggleFlag(_ flag: RedFlag) {
        if assessment.redFlags.contains(flag) {
            assessment.redFlags.removeAll { $0 == flag }
        } else {
            assessment.redFlags.append(flag)
        }
    }
}

struct StepNotes: View {
    @Binding var assessment: PainAssessment
    @State private var notesText = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Any additional notes about your pain?")
                .font(.title2.weight(.semibold))
                .foregroundStyle(PainUI.Theme.textPrimary)
            
            Text("(Optional)")
                .font(.subheadline)
                .foregroundStyle(PainUI.Theme.textSecondary)
            
            TextEditor(text: $notesText)
                .font(.body)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(height: 150)
                .background(PainUI.Theme.card)
                .clipShape(RoundedRectangle(cornerRadius: PainUI.Layout.cardCornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: PainUI.Layout.cardCornerRadius)
                        .stroke(PainUI.Theme.textSecondary.opacity(0.2), lineWidth: 1)
                )
                .onChange(of: notesText) { _, newValue in
                    assessment.notes = newValue
                }
                .onAppear {
                    notesText = assessment.notes
                }
        }
    }
}

#Preview {
    FixPainAssessmentView(area: .back) { _ in }
}