import SwiftUI

struct MobilityViewEF: View, Identifiable {
    let id = UUID()
    @State private var region: String = "Back"
    @State private var duration: Int = 15
    @State private var walk = false
    @State private var dynamicStretch = false
    @State private var foamRoll = false
    @State private var notes: String = ""
    @EnvironmentObject private var theme: EFThemeManager
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let isDark = theme.isDark(colorScheme)
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
                                        .efText(.primary)
                                    Text("Loosen up tight areas")
                                        .font(.subheadline)
                                        .efText(.secondary)
                                }
                                Spacer()
                            }
                        }

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Focus")
                                    .font(.subheadline)
                                    .efText(.secondary)
                                Picker("", selection: $region) {
                                    Text("Neck")
                                        .tag("Neck")
                                        .efText(.primary)
                                    Text("Shoulders")
                                        .tag("Shoulders")
                                        .efText(.primary)
                                    Text("Back")
                                        .tag("Back")
                                        .efText(.primary)
                                    Text("Hips")
                                        .tag("Hips")
                                        .efText(.primary)
                                    Text("Knees")
                                        .tag("Knees")
                                        .efText(.primary)
                                    Text("Ankles")
                                        .tag("Ankles")
                                        .efText(.primary)
                                }
                                .pickerStyle(.segmented)

                                Stepper("Duration: \(duration) min", value: $duration, in: 5...90, step: 5)
                                    .efText(.primary)
                                Toggle("Walk", isOn: $walk)
                                    .efText(.primary)
                                Toggle("Dynamic stretch", isOn: $dynamicStretch)
                                    .efText(.primary)
                                Toggle("Foam roll", isOn: $foamRoll)
                                    .efText(.primary)
                            }
                        }

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Notes")
                                    .font(.subheadline)
                                    .efText(.secondary)
                                TextEditor(text: $notes)
                                    .frame(minHeight: 120)
                                    .scrollContentBackground(.hidden)
                                    .efText(.primary)
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
                .toolbarBackground(isDark ? theme.tokens.darkBG : Color.clear, for: .navigationBar)
                .toolbarColorScheme(isDark ? .dark : nil, for: .navigationBar)
                .efScreenBackground()
            }
        }
    }
}
