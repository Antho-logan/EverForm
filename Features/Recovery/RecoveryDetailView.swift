import SwiftUI

struct RecoveryDetailView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                HStack(spacing: 10) {
                    Image(systemName: "moon.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.blue)   // Recovery accent
                    Text("Recovery")
                        .font(.largeTitle.bold())
                        .foregroundStyle(DSColor.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 4)

                EFCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Sleep").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        HStack {
                            Text("7h 30m").font(.title3.bold()).foregroundStyle(DSColor.textPrimary)
                            Spacer()
                            Button("Open") { /* later */ }.buttonStyle(.bordered)
                        }
                        ProgressView(value: 0.78).tint(.blue)
                    }
                }

                EFCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Readiness").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        Text("HRV trending up • take it easy today").foregroundStyle(DSColor.textPrimary)
                    }
                }

                EFCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Routines").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        ForEach(["Breathwork", "Mobility reset"], id: \.self) { r in
                            HStack { Text(r); Spacer(); Image(systemName: "chevron.right") }
                                .foregroundStyle(DSColor.textPrimary)
                                .padding(.vertical, 6)
                        }
                    }
                }

            }.padding(16)
        }
        .background(DSColor.appBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}


