//
//  BreathingRingView.swift
//  EverForm
//
//  Modern animated breathing ring with gradient and glow effects
//

import SwiftUI

enum BreathPhase: CaseIterable {
    case inhale, hold1, exhale, hold2

    var label: String {
        switch self {
        case .inhale: return "Inhale"
        case .hold1: return "Hold"
        case .exhale: return "Exhale"
        case .hold2: return "Hold"
        }
    }

    var color: Color {
        switch self {
        case .inhale: return .blue
        case .hold1: return .purple
        case .exhale: return .green
        case .hold2: return .teal
        }
    }
}

struct BreathingRingView: View {
    var progress: CGFloat // 0.0...1.0 for current phase
    var phase: BreathPhase
    var timeLeft: Int

    @State private var scaleEffect: CGFloat = 1.0
    @State private var glowIntensity: Double = 0.3

    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(
                    AngularGradient(
                        colors: [phase.color.opacity(0.1), phase.color.opacity(0.05)],
                        center: .center
                    ),
                    lineWidth: 20
                )
                .frame(width: 220, height: 220)

            // Progress ring with gradient
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AngularGradient(
                        colors: [
                            phase.color.opacity(0.8),
                            phase.color,
                            phase.color.opacity(0.8)
                        ],
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 220, height: 220)
                .scaleEffect(scaleEffect)
                .shadow(
                    color: phase.color.opacity(glowIntensity),
                    radius: 15,
                    x: 0,
                    y: 0
                )
                .animation(
                    .easeInOut(duration: 0.5),
                    value: [scaleEffect, glowIntensity]
                )

            // Moving dot at the end of the progress
            Circle()
                .fill(phase.color)
                .frame(width: 12, height: 12)
                .shadow(
                    color: phase.color.opacity(glowIntensity * 2),
                    radius: 8,
                    x: 0,
                    y: 0
                )
                .offset(
                    x: cos(progress * 2 * .pi - .pi/2) * 110,
                    y: sin(progress * 2 * .pi - .pi/2) * 110
                )
                .animation(
                    .easeInOut(duration: 0.3),
                    value: progress
                )

            // Timer text
            Text("\(timeLeft)")
                .font(.system(size: 44, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(DSColor.textPrimary)
        }
        .onAppear {
            updateAnimationForPhase()
        }
        .onChange(of: phase) { _ in
            updateAnimationForPhase()
        }
    }

    private func updateAnimationForPhase() {
        withAnimation(.easeInOut(duration: 0.5)) {
            switch phase {
            case .inhale:
                scaleEffect = 1.05
                glowIntensity = 0.6
            case .hold1:
                scaleEffect = 1.02
                glowIntensity = 0.4
            case .exhale:
                scaleEffect = 0.95
                glowIntensity = 0.2
            case .hold2:
                scaleEffect = 0.98
                glowIntensity = 0.3
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        BreathingRingView(progress: 0.7, phase: .inhale, timeLeft: 3)
        Text("Inhale Phase").font(.headline)
    }
    .padding()
    .background(DSColor.bg)
}