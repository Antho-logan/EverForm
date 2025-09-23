import SwiftUI

struct TodayPlanSheet: View {
    let onStartWorkout: () -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Today's Training")
                .font(.title2.weight(.bold))
                .foregroundStyle(DSColor.textPrimary)

            EFCard {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Upper Power")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(DSColor.textPrimary)

                    Text("Duration: 75 minutes")
                        .foregroundStyle(DSColor.textSecondary)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Main Exercises:")
                            .font(.headline)
                            .foregroundStyle(DSColor.textPrimary)
                        Text("• Bench Press")
                            .foregroundStyle(DSColor.textPrimary)
                        Text("• Pull-ups")
                            .foregroundStyle(DSColor.textPrimary)
                        Text("• Overhead Press")
                            .foregroundStyle(DSColor.textPrimary)
                    }
                }
                .padding()
            }
            
            Button("Start Workout", action: onStartWorkout)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding(.horizontal, EFSpacing.page)
        .padding(.vertical, EFSpacing.section)
        .background(DSColor.bg.ignoresSafeArea())
        .navigationTitle("Training Plan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Close", action: onClose)
            }
        }
    }
}