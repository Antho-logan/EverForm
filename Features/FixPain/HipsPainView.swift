import SwiftUI

struct HipsPainView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: NavigationRouter
    @State private var isStarted = false
    @State private var currentStep = 0
    @State private var timer: Timer?
    @State private var timeRemaining = 30
    @GestureState private var drag: CGFloat = 0

    var routine: [RoutineStep] {
        return [
            RoutineStep(name: "Hip Circles", duration: 20, description: "Joint mobility"),
            RoutineStep(name: "Pigeon Pose", duration: 45, description: "Deep hip stretch"),
            RoutineStep(name: "Figure-4 Stretch", duration: 30, description: "Hip flexor release"),
            RoutineStep(name: "Glute Bridge", duration: 25, description: "Hip strengthening")
        ]
    }

    struct RoutineStep {
        let name: String
        let duration: Int
        let description: String
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Hips")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(DSColor.textPrimary)

                Text("Hip tightness or discomfort")
                    .font(.body)
                    .foregroundStyle(DSColor.textSecondary)

                if !isStarted {
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Text("Hip Relief")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(DSColor.textPrimary)
                            Text("A targeted routine to help relieve hip discomfort")
                                .font(.body)
                                .foregroundStyle(DSColor.textSecondary)
                                .multilineTextAlignment(.center)
                        }

                        VStack(spacing: 12) {
                            ForEach(Array(routine.enumerated()), id: \.offset) { index, step in
                                EFCard {
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color.blue.opacity(0.15))
                                                .frame(width: 32, height: 32)
                                            Text("\(index + 1)")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundStyle(Color.blue)
                                        }
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(step.name)
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundStyle(DSColor.textPrimary)
                                            Text(step.description)
                                                .font(.system(size: 14, weight: .regular))
                                                .foregroundStyle(DSColor.textSecondary)
                                        }
                                        Spacer()
                                        Text("\(step.duration)s")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundStyle(DSColor.textSecondary)
                                    }
                                }
                            }
                        }

                        Button(action: startRoutine) {
                            Text("Start Routine")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Step \(currentStep + 1) of \(routine.count)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(DSColor.textSecondary)
                            ProgressView(value: Double(currentStep), total: Double(routine.count))
                                .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                        }
                        Spacer()
                        VStack(spacing: 20) {
                            Text(routine[currentStep].name)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(DSColor.textPrimary)
                                .multilineTextAlignment(.center)
                            Text(routine[currentStep].description)
                                .font(.system(size: 18, weight: .regular))
                                .foregroundStyle(DSColor.textSecondary)
                                .multilineTextAlignment(.center)
                            ZStack {
                                Circle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 8)
                                    .frame(width: 120, height: 120)
                                Text("\(timeRemaining)")
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundStyle(Color.blue)
                                    .contentTransition(.numericText())
                            }
                        }
                        Spacer()
                        HStack(spacing: 24) {
                            Button("Skip") {
                                nextStep()
                            }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(DSColor.textSecondary)
                            Spacer()
                            Button("Stop") {
                                stopRoutine()
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.blue)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                }
            }
            .padding(24)
        }
        .scrollIndicators(.hidden)
        .background(DSColor.bg.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .offset(y: max(0, drag))
        .gesture(
            DragGesture(minimumDistance: 8, coordinateSpace: .local)
                .updating($drag) { value, state, _ in
                    if value.translation.height > 0 { state = value.translation.height }
                }
                .onEnded { value in
                    if value.translation.height > 120 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.86)) {
                            dismiss()
                        }
                    }
                }
        )
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: drag)
        .allowsHitTesting(true)
    }

    private func startRoutine() {
        isStarted = true
        currentStep = 0
        startStepTimer()
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }

    private func stopRoutine() {
        isStarted = false
        timer?.invalidate()
        timer = nil
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    private func startStepTimer() {
        timeRemaining = routine[currentStep].duration
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timeRemaining -= 1
            if timeRemaining <= 0 {
                nextStep()
            }
        }
    }

    private func nextStep() {
        timer?.invalidate()
        if currentStep < routine.count - 1 {
            currentStep += 1
            startStepTimer()
        } else {
            stopRoutine()
            let success = UINotificationFeedbackGenerator()
            success.notificationOccurred(.success)
        }
    }
}