import SwiftUI

struct MobilityViewEF: View, Identifiable {
    let id = UUID()
    @State private var region: String = "Back"
    @State private var duration: Int = 15
    @State private var walk = false
    @State private var dynamicStretch = false
    @State private var foamRoll = false
    @State private var notes: String = ""

    var body: some View {
        ZStack {
            Color("AppBackground").ignoresSafeArea()
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        EFCard {
                            HStack(spacing: 12) {
                                Image(systemName: "figure.walk.motion")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(.purple) // Mobility color
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Mobility")
                                        .font(.headline)
                                        .foregroundStyle(Color("TextPrimary"))
                                    Text("Loosen up tight areas")
                                        .font(.subheadline)
                                        .foregroundStyle(Color("TextSecondary"))
                                }
                                Spacer()
                            }
                        }

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Focus").font(.subheadline).foregroundStyle(Color("TextSecondary"))
                                Picker("", selection: $region) {
                                    Text("Neck").tag("Neck")
                                    Text("Shoulders").tag("Shoulders")
                                    Text("Back").tag("Back")
                                    Text("Hips").tag("Hips")
                                    Text("Knees").tag("Knees")
                                    Text("Ankles").tag("Ankles")
                                }
                                .pickerStyle(.segmented)

                                Stepper("Duration: \(duration) min", value: $duration, in: 5...90, step: 5)
                                Toggle("Walk", isOn: $walk)
                                Toggle("Dynamic stretch", isOn: $dynamicStretch)
                                Toggle("Foam roll", isOn: $foamRoll)
                            }
                        }

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Notes").font(.subheadline).foregroundStyle(Color("TextSecondary"))
                                TextEditor(text: $notes).frame(minHeight: 120)
                                    .scrollContentBackground(.hidden)
                            }
                        }

                        Button(action: {
                            // Hook to real flow later
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Save Mobility")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(.purple)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .navigationTitle("Mobility")
                .efScreenBackground()
            }
        }
    }
}
