//
//  BreathworkView.swift
//  EverForm
//
//  Full-screen breathwork experience with animated breathing ring
//

import SwiftUI
import UIKit

struct BreathPattern: Identifiable {
    let id = UUID()
    let name: String
    let phases: [(label: String, seconds: Int)]
}

private let patterns: [BreathPattern] = [
    .init(name: "4-7-8", phases: [("Inhale",4),("Hold",7),("Exhale",8)]),
    .init(name: "Box",  phases: [("Inhale",4),("Hold",4),("Exhale",4),("Hold",4)]),
    .init(name: "Deep", phases: [("Inhale",6),("Exhale",6)])
]

struct BreathworkView: View {
    @Environment(\.colorScheme) private var scheme
    @State private var selected = patterns.first!
    
    private var semanticColors: Theme.SemanticColors {
        Theme.semantic(scheme)
    }
    @State private var running = false
    @State private var phaseIndex = 0
    @State private var t: Double = 0

    var body: some View {
        ZStack {
            semanticColors.page.ignoresSafeArea()
            if running {
                sessionView
            } else {
                listView
            }
        }
        .scrollContentBackground(.hidden)
        .toolbarBackground(Color(semanticColors.page), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationTitle("Breathwork")
        .navigationBarTitleDisplayMode(.large)
        .onAppear { NavBlendLocal.apply() }
        .onDisappear { EFNavBarStyler.resetToDefault() }
    }

    private var listView: some View {
        VStack(spacing: 16) {
            ForEach(patterns) { p in
                HStack {
                    Text(p.name).font(.headline).foregroundStyle(DSColor.textPrimary)
                    Spacer()
                    if p.id == selected.id { Image(systemName: "checkmark.circle.fill").foregroundStyle(.green) }
                }
                .padding()
                .background(DSColor.card)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .onTapGesture { selected = p }
            }

            Button {
                start()
            } label: {
                Text("Start Session")
                    .font(.headline).frame(maxWidth: .infinity)
                    .padding().background(Color.green).foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding()
    }

    private var sessionView: some View {
        VStack(spacing: 24) {
            Text(selected.phases[phaseIndex].label)
                .font(.title.bold())
                .foregroundStyle(DSColor.textPrimary)

            ZStack {
                Circle()
                    .stroke(Color.green.opacity(0.2), lineWidth: 18)
                    .frame(width: 220, height: 220)

                Circle()
                    .trim(from: 0, to: t)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 220, height: 220)
                    .animation(.linear(duration: 1), value: t)

                Text("\(timeLeft)")
                    .font(.system(size: 44, weight: .bold))
                    .monospacedDigit()
                    .foregroundStyle(DSColor.textPrimary)
            }

            Button {
                stop()
            } label: {
                Text("Stop Session")
                    .font(.headline).frame(maxWidth: .infinity)
                    .padding().background(Color.red.opacity(0.9)).foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
        }
        .padding()
        .onAppear { tick() }
    }

    private var timeLeft: Int { max(0, currentPhaseSeconds - Int(round(progressSeconds))) }
    private var currentPhaseSeconds: Int { selected.phases[phaseIndex].seconds }
    @State private var progressSeconds: Double = 0
    private var totalPhase: Double { Double(currentPhaseSeconds) }

    private func start() {
        running = true; phaseIndex = 0; progressSeconds = 0; t = 0
    }
    private func stop() { running = false }

    private func tick() {
        guard running else { return }
        withAnimation(.linear(duration: 1)) {
            progressSeconds += 1
            t = progressSeconds / totalPhase
        }
        if progressSeconds >= totalPhase {
            // next phase
            progressSeconds = 0; t = 0
            phaseIndex = (phaseIndex + 1) % selected.phases.count
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { tick() }
    }
}

#Preview {
    BreathworkView()
}
