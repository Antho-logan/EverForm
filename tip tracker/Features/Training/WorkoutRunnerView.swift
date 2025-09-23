import SwiftUI

struct WorkoutRunnerView: View {
    let onFinish: () -> Void
    let onDiscard: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Workout in Progress")
                .font(.title2.weight(.bold))
                .foregroundStyle(DSColor.textPrimary)

            Text("Upper Power Workout")
                .font(.title3)
                .foregroundStyle(DSColor.textSecondary)

            // Mock workout content
            EFCard {
                VStack(spacing: 16) {
                    Text("Exercise 1: Bench Press")
                        .foregroundStyle(DSColor.textPrimary)
                    Text("Set 1 of 3")
                        .foregroundStyle(DSColor.textSecondary)

                    HStack {
                        Button("Log Set") {
                            // Handle set logging
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Skip Set") {
                            // Handle skip
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            
            Spacer()
            
            HStack {
                Button("Discard", action: onDiscard)
                    .buttonStyle(.bordered)
                    .foregroundStyle(.red)
                
                Button("Finish Workout", action: onFinish)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(.horizontal, EFSpacing.page)
        .padding(.vertical, EFSpacing.section)
        .background(DSColor.bg.ignoresSafeArea())
        .navigationTitle("Workout")
        .navigationBarTitleDisplayMode(.inline)
    }
}