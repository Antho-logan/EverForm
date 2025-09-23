//
//  RecoveryView.swift
//  EverForm
//
//  Recovery feature page
//

import SwiftUI

struct RecoveryView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var journalStore: JournalStore

    @State private var selectedDate = Date()
    @State private var bedtime = Calendar.current.date(bySettingHour: 22, minute: 30, second: 0, of: Date()) ?? Date()
    @State private var routineSteps = JournalRecoveryStep.defaultSteps
    @State private var selectedDuration = 15
    @State private var isSessionActive = false
    @State private var sessionSeconds = 0
    @State private var timer: Timer?
    @State private var showingSaveConfirmation = false
    @State private var autoFocusSession = false

    private let durations = [5, 10, 15, 20, 30]

    init(autoFocusSession: Bool = false) {
        self._autoFocusSession = State(initialValue: autoFocusSession)
    }

    var body: some View {
        let theme = EnvironmentValues().efTheme

        ZStack {
            DSColor.bg.ignoresSafeArea()
            ScrollView {
            VStack(spacing: EFSpacing.section) {
                // Wind-down Section
                EFCard {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        HStack {
                            Image(systemName: "moon.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(Color(hex: "BF5AF2"))

                            Text("Wind-down")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(theme.textPrimary)

                            Spacer()
                        }

                        VStack(spacing: Spacing.md) {
                            // Bedtime
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Bedtime")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(theme.textSecondary)

                                DatePicker("", selection: $bedtime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(.wheel)
                                    .frame(height: 100)
                            }

                            // Routine Checklist
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Routine Checklist")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(theme.textSecondary)

                                ForEach(routineSteps.indices, id: \.self) { index in
                                    HStack {
                                        Button(action: {
                                            routineSteps[index].done.toggle()
                                            let impact = UIImpactFeedbackGenerator(style: .light)
                                            impact.impactOccurred()
                                        }) {
                                            Image(systemName: routineSteps[index].done ? "checkmark.circle.fill" : "circle")
                                                .font(.system(size: 20, weight: .medium))
                                                .foregroundStyle(routineSteps[index].done ? .green : theme.textSecondary)
                                        }
                                        .frame(width: 44, height: 44)

                                        Text(routineSteps[index].title)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundStyle(theme.textPrimary)
                                            .strikethrough(routineSteps[index].done)

                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }

                // Session Section
                EFCard {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        HStack {
                            Image(systemName: "timer")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.purple)

                            Text("Session")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(theme.textPrimary)

                            Spacer()
                        }

                        if isSessionActive {
                            VStack(spacing: Spacing.md) {
                                Text(formatTime(sessionSeconds))
                                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                                    .foregroundStyle(theme.textPrimary)

                                HStack(spacing: Spacing.md) {
                                    EFPillButton(
                                        title: "Pause",
                                        style: .secondary
                                    ) {
                                        pauseSession()
                                    }

                                    EFPillButton(
                                        title: "Complete",
                                        style: .primary,
                                        color: .green
                                    ) {
                                        completeSession()
                                    }
                                }
                            }
                        } else {
                            VStack(spacing: Spacing.md) {
                                // Duration picker
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Duration")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(theme.textSecondary)

                                    Picker("Duration", selection: $selectedDuration) {
                                        ForEach(durations, id: \.self) { duration in
                                            Text("\(duration) min").tag(duration)
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                }

                                EFPillButton(
                                    title: "Start Wind-Down",
                                    style: .primary,
                                    color: .blue
                                ) {
                                    startSession()
                                }
                            }
                        }
                    }
                }

                // Save Button
                if !isSessionActive {
                    EFPillButton(
                        title: "Save Recovery",
                        style: .primary
                    ) {
                        saveRecovery()
                    }
                }

                Spacer(minLength: 100)
            }
            .padding(.horizontal, EFSpacing.page)
            .padding(.vertical, EFSpacing.section)
        }
        }
        .toolbarBackground(DSColor.barBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationTitle("Recovery")
        .navigationBarTitleDisplayMode(.large)
        .scrollContentBackground(.hidden)
        .onAppear {
            if autoFocusSession {
                startSession()
            }
        }
        .alert("Recovery Saved!", isPresented: $showingSaveConfirmation) {
            Button("OK") { }
        } message: {
            Text("Your recovery session has been saved successfully.")
        }
    }


    // MARK: - Helper Methods

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
        saveRecovery()
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    private func saveRecovery() {
        let entry = JournalRecoveryEntry(
            date: selectedDate,
            bedtime: bedtime,
            routine: routineSteps,
            durationMin: selectedDuration
        )

        journalStore.addRecovery(entry)
        showingSaveConfirmation = true

        // Reset routine steps
        routineSteps = JournalRecoveryStep.defaultSteps
    }
}

#Preview {
    NavigationStack {
        RecoveryView()
            .environmentObject(JournalStore())
    }
}
