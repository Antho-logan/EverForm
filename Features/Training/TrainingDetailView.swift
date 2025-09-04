import SwiftUI

struct TrainingDetailView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                HStack(spacing: 10) {
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.green)
                    Text("Training")
                        .font(.largeTitle.bold())
                        .foregroundStyle(DSColor.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 4)

                EFCard {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Today").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                            Text("Upper Body • 45 min")
                                .font(.title3.bold()).foregroundStyle(DSColor.textPrimary)
                        }
                        Spacer()
                        Button("Start Workout") { /* hook later */ }
                            .buttonStyle(.borderedProminent)
                    }
                }

                EFCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Plan").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        ForEach(["Push", "Pull", "Legs"], id: \.self) { s in
                            HStack { Text(s); Spacer(); Image(systemName: "chevron.right") }
                                .foregroundStyle(DSColor.textPrimary)
                                .padding(.vertical, 6)
                        }
                    }
                }

                EFCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        Text("Keep elbows tucked on presses; reduce ROM on rows if shoulder flares.")
                            .foregroundStyle(DSColor.textPrimary)
                    }
                }

            }.padding(16)
        }
        .background(DSColor.appBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}


