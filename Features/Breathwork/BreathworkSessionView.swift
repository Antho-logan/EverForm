//
//  BreathworkSessionView.swift
//  EverForm
//
//  Modern breathwork session view with timer and animations
//

import SwiftUI
import UIKit

struct BreathworkSessionView: View {
    let pattern: BreathPattern
    @Binding var isRunning: Bool
    @Environment(\.dismiss) private var dismiss

    @State private var currentPhaseIndex: Int = 0
    @State private var phaseProgress: Double = 0
    @State private var timeLeft: Int = 0
    @State private var cyclesCompleted: Int = 0
    @State private var timer: Timer?

    private var currentPhase: BreathPhase {
        pattern.phases[currentPhaseIndex].phase
    }

    private var currentPhaseDuration: Int {
        pattern.phases[currentPhaseIndex].seconds
    }

    var body: some View {
        VStack(spacing: 32) {
            // Phase label
            VStack(spacing: 8) {
                Text(currentPhase.label)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(DSColor.textPrimary)

                Text("Cycle \(cyclesCompleted + 1)")
                    .font(.subheadline)
                    .foregroundStyle(DSColor.textSecondary)
            }

            // Breathing ring
            BreathingRingView(
                progress: CGFloat(phaseProgress),
                phase: currentPhase,
                timeLeft: timeLeft
            )

            // Progress indicator
            VStack(spacing: 4) {
                ProgressView(value: phaseProgress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: currentPhase.color))

                Text("\(Int(phaseProgress * 100))%")
                    .font(.caption)
                    .foregroundStyle(DSColor.textSecondary)
            }
            .padding(.horizontal, 40)

            Spacer()

            // Stop button
            Button {
                stopSession()
            } label: {
                Text("Stop Session")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundStyle(.white)
                    .background(Color.red.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(EFTheme.appBackground.ignoresSafeArea())
        .onAppear {
            if isRunning {
                startSession()
            }
        }
        .onChange(of: isRunning) { running in
            if running {
                startSession()
            } else {
                stopSession()
            }
        }
        .onDisappear {
            stopSession()
        }
    }

    private func startSession() {
        currentPhaseIndex = 0
        phaseProgress = 0
        timeLeft = currentPhaseDuration
        cyclesCompleted = 0

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateSession()
        }
    }

    private func stopSession() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    private func updateSession() {
        phaseProgress += 0.1 / Double(currentPhaseDuration)
        timeLeft = max(0, currentPhaseDuration - Int(phaseProgress * Double(currentPhaseDuration)))

        if phaseProgress >= 1.0 {
            // Move to next phase
            phaseProgress = 0
            currentPhaseIndex = (currentPhaseIndex + 1) % pattern.phases.count

            // Check if we completed a full cycle
            if currentPhaseIndex == 0 {
                cyclesCompleted += 1

                // Trigger haptic feedback on phase change
                #if !targetEnvironment(simulator)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                #endif
            }
        }
    }
}

#Preview {
    BreathworkSessionView(
        pattern: BreathPattern(name: "4-7-8", phases: [
            (.inhale, 4),
            (.hold1, 7),
            (.exhale, 8)
        ]),
        isRunning: .constant(true)
    )
}