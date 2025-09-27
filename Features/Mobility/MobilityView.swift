//
//  MobilityView.swift
//  EverForm
//
//  Mobility feature page
//

import SwiftUI

// MARK: - Type Definitions
private struct MobilityRegionItem: Identifiable, Hashable {
    let id: UUID = UUID()
    let region: JournalBodyRegion
    let isSelected: Bool
    let action: () -> Void

    // MARK: - Hashable Conformance
    static func == (lhs: MobilityRegionItem, rhs: MobilityRegionItem) -> Bool {
        lhs.id == rhs.id && lhs.region == rhs.region && lhs.isSelected == rhs.isSelected
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(region)
        hasher.combine(isSelected)
    }
}

private struct SessionDurationItem: Identifiable, Hashable {
    let id: Int
    let minutes: Int
    var title: String { "\(minutes) min" }
}

struct MobilityView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var journalStore: JournalStore

    @State private var selectedDate = Date()
    @State private var selectedRegions: Set<JournalBodyRegion> = []
    @State private var routineSteps = JournalMobilityStep.defaultSteps
    @State private var selectedDuration = 10
    @State private var isSessionActive = false
    @State private var sessionSeconds = 0
    @State private var timer: Timer?
    @State private var showingSaveConfirmation = false
    @State private var autoStartSession = false

    // MARK: - Grid Configuration
    private let regionColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    private let durations: [SessionDurationItem] = [5, 10, 15, 20, 30].map { SessionDurationItem(id: $0, minutes: $0) }

    init(autoStartSession: Bool = false) {
        self._autoStartSession = State(initialValue: autoStartSession)
    }

    
    // MARK: - Main Body
    var body: some View {
        ZStack {
            DSColor.bg.ignoresSafeArea()
            content
        }
        .toolbarBackground(DSColor.barBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationTitle("Mobility")
        .navigationBarTitleDisplayMode(.large)
        .scrollContentBackground(.hidden)
        .onAppear {
            if autoStartSession {
                startSession()
            }
        }
        .alert("Mobility Saved!", isPresented: $showingSaveConfirmation) {
            Button("OK") { }
        } message: {
            Text("Your mobility session has been saved successfully.")
        }
    }

    // MARK: - Content Builder
    @ViewBuilder
    private var content: some View {
        ScrollView {
            VStack(spacing: EFSpacing.section) {
                FocusSectionView(
                    selectedRegions: $selectedRegions,
                    columns: regionColumns,
                    onRegionToggle: toggleRegion
                )

                RoutineSectionView(
                    routineSteps: $routineSteps,
                    onAddStep: addRoutineStep,
                    onRemoveStep: removeRoutineStep
                )

                if isSessionActive {
                    ActiveSessionView(
                        sessionSeconds: sessionSeconds,
                        onPause: pauseSession,
                        onComplete: completeSession
                    )
                }

                SessionControlsView(
                    isSessionActive: isSessionActive,
                    selectedDuration: $selectedDuration,
                    durations: durations,
                    selectedRegions: selectedRegions,
                    onStartSession: startSession,
                    onSaveMobility: saveMobility
                )

                Spacer(minLength: 100)
            }
            .padding(.horizontal, EFSpacing.page)
            .padding(.vertical, EFSpacing.section)
        }
    }

    // MARK: - Helper Methods

    private func toggleRegion(_ region: JournalBodyRegion) {
        if selectedRegions.contains(region) {
            selectedRegions.remove(region)
        } else {
            selectedRegions.insert(region)
        }

        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    private func addRoutineStep() {
        routineSteps.append(JournalMobilityStep(title: "", repsOrSecs: "30s"))
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    private func removeRoutineStep(at index: Int) {
        routineSteps.remove(at: index)
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    private func startSession() {
        isSessionActive = true
        sessionSeconds = selectedDuration * 60

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if sessionSeconds > 0 {
                sessionSeconds -= 1
            } else {
                completeSession()
            }
        }

        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }

    private func pauseSession() {
        isSessionActive = false
        timer?.invalidate()
        timer = nil

        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    private func completeSession() {
        pauseSession()
        sessionSeconds = 0

        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        // Auto-save when session completes
        saveMobility()
    }

    private func saveMobility() {
        let entry = JournalMobilityEntry(
            date: selectedDate,
            focusAreas: Array(selectedRegions),
            durationMin: selectedDuration,
            routine: routineSteps.filter { !$0.title.isEmpty }
        )

        journalStore.addMobility(entry)
        showingSaveConfirmation = true

        // Reset form
        selectedRegions.removeAll()
        routineSteps = JournalMobilityStep.defaultSteps
    }
}

// MARK: - Focus Section View
private struct FocusSectionView: View {
    @Binding var selectedRegions: Set<JournalBodyRegion>
    let columns: [GridItem]
    let onRegionToggle: (JournalBodyRegion) -> Void

    
    var body: some View {
        EFCard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                headerView

                VStack(spacing: Spacing.md) {
                    Text("Select body regions to focus on")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(DSColor.textSecondary)

                    regionGrid
                }
            }
        }
    }

    private var headerView: some View {
        HStack {
            Image(systemName: "figure.flexibility")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.purple)

            Text("Focus")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(DSColor.textPrimary)

            Spacer()
        }
    }

    private var regionGrid: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(regionItems) { item in
                RegionButton(item: item)
            }
        }
    }

    private var regionItems: [MobilityRegionItem] {
        JournalBodyRegion.allCases.map { region in
            MobilityRegionItem(
                region: region,
                isSelected: selectedRegions.contains(region)
            ) {
                onRegionToggle(region)
            }
        }
    }
}

// MARK: - Region Button
private struct RegionButton: View {
    let item: MobilityRegionItem

    
    var body: some View {
        Button(action: item.action) {
            Text(item.region.rawValue)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(item.isSelected ? .white : DSColor.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(item.isSelected ? DSColor.accentPrimary : DSColor.card)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.clear, lineWidth: item.isSelected ? 0 : 1)
                )
        }
        .buttonStyle(.plain)
        .frame(minHeight: 44)
    }
}

// MARK: - Routine Section View
private struct RoutineSectionView: View {
    @Binding var routineSteps: [JournalMobilityStep]
    let onAddStep: () -> Void
    let onRemoveStep: (Int) -> Void

    
    var body: some View {
        EFCard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                headerView

                ForEach(routineSteps.indices, id: \.self) { index in
                    MobilityStepRow(
                        step: $routineSteps[index],
                        onDelete: { onRemoveStep(index) }
                    )
                }
            }
        }
    }

    private var headerView: some View {
        HStack {
            Image(systemName: "list.bullet")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.green)

            Text("Routine")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(DSColor.textPrimary)

            Spacer()

            Button(action: onAddStep) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(DSColor.accentPrimary)
            }
            .accessibilityLabel("Add routine step")
        }
    }
}

// MARK: - Active Session View
private struct ActiveSessionView: View {
    let sessionSeconds: Int
    let onPause: () -> Void
    let onComplete: () -> Void

    
    var body: some View {
        EFCard {
            VStack(spacing: Spacing.md) {
                headerView

                Text(formatTime(sessionSeconds))
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundStyle(DSColor.textPrimary)

                HStack(spacing: Spacing.md) {
                    EFPillButton(
                        title: "Pause",
                        style: .secondary
                    ) {
                        onPause()
                    }

                    EFPillButton(
                        title: "Complete",
                        style: .primary,
                        color: .green
                    ) {
                        onComplete()
                    }
                }
            }
        }
    }

    private var headerView: some View {
        HStack {
            Image(systemName: "timer")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.orange)

            Text("Session Active")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(DSColor.textPrimary)

            Spacer()
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

// MARK: - Session Controls View
private struct SessionControlsView: View {
    let isSessionActive: Bool
    @Binding var selectedDuration: Int
    let durations: [SessionDurationItem]
    let selectedRegions: Set<JournalBodyRegion>
    let onStartSession: () -> Void
    let onSaveMobility: () -> Void

    
    var body: some View {
        VStack(spacing: Spacing.md) {
            if !isSessionActive {
                DurationPickerView(
                    selectedDuration: $selectedDuration,
                    durations: durations
                )

                EFPillButton(
                    title: "Start Session",
                    style: .primary,
                    color: .purple
                ) {
                    onStartSession()
                }
                .disabled(selectedRegions.isEmpty)
            }

            if !isSessionActive {
                EFPillButton(
                    title: "Save Routine",
                    style: .primary
                ) {
                    onSaveMobility()
                }
                .disabled(selectedRegions.isEmpty)
            }
        }
    }
}

// MARK: - Duration Picker View
private struct DurationPickerView: View {
    @Binding var selectedDuration: Int
    let durations: [SessionDurationItem]

    
    var body: some View {
        EFCard {
            VStack(alignment: .leading, spacing: Spacing.md) {
                Text("Session Duration")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(DSColor.textPrimary)

                Picker("Duration", selection: $selectedDuration) {
                    ForEach(durations) { duration in
                        Text(duration.title).tag(duration.minutes)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

// MARK: - Mobility Step Row Component

private struct MobilityStepRow: View {
    @Binding var step: JournalMobilityStep
    let onDelete: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let theme = EnvironmentValues().efTheme

        VStack(spacing: 8) {
            HStack {
                TextField("Exercise name", text: $step.title)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 16, weight: .medium))

                Button(action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.red)
                }
                .frame(width: 44, height: 44)
                .accessibilityLabel("Remove step")
            }

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Duration/Reps")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(DSColor.textSecondary)

                    TextField("30s", text: $step.repsOrSecs)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                }

                Spacer()
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        MobilityView()
            .environmentObject(JournalStore())
    }
}
