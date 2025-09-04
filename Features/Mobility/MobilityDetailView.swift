import SwiftUI

struct MobilityDetailView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                HStack(spacing: 10) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.purple) // Mobility accent
                    Text("Mobility")
                        .font(.largeTitle.bold())
                        .foregroundStyle(DSColor.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 4)

                EFCard {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Focus").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                            Text("Hips & Shoulders • 8 min")
                                .font(.title3.bold()).foregroundStyle(DSColor.textPrimary)
                        }
                        Spacer()
                        Button("Start") { /* later */ }.buttonStyle(.borderedProminent).tint(.purple)
                    }
                }

                EFCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Library").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        ForEach(["Thoracic openers", "Hip flexor release", "90/90 flow"], id: \.self) { m in
                            HStack { Text(m); Spacer(); Image(systemName: "chevron.right") }
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


