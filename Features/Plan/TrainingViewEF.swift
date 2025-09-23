import SwiftUI

struct TrainingViewEF: View, Identifiable {
    let id = UUID()
    @State private var selectedType: String = "Strength"
    @State private var duration: Int = 45
    @State private var notes: String = ""
    @EnvironmentObject private var theme: EFThemeManager
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let isDark = theme.isDark(colorScheme)
        ZStack {
            DSColor.bg.ignoresSafeArea()
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        EFCard {
                            HStack(spacing: 12) {
                                Image(systemName: "dumbbell.fill")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(DSColor.accentSuccess)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Session")
                                        .font(.headline)
                                        .efText(.primary)
                                    Text("Set up your training session")
                                        .font(.subheadline)
                                        .efText(.secondary)
                                }
                                Spacer()
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.snappy(duration: 0.25), value: selectedType)

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Type")
                                    .font(.subheadline)
                                    .efText(.secondary)
                                Picker("", selection: $selectedType) {
                                    Text("Strength").tag("Strength")
                                        .efText(.primary)
                                    Text("Cardio").tag("Cardio")
                                        .efText(.primary)
                                    Text("HIIT").tag("HIIT")
                                        .efText(.primary)
                                    Text("Mobility").tag("Mobility")
                                        .efText(.primary)
                                }
                                .pickerStyle(.segmented)

                                Stepper("Duration: \(duration) min", value: $duration, in: 5...180, step: 5)
                                    .font(.body)
                                    .efText(.primary)
                            }
                        }

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Notes")
                                    .font(.subheadline)
                                    .efText(.secondary)
                                TextEditor(text: $notes).frame(minHeight: 120)
                                    .scrollContentBackground(.hidden)
                                    .efText(.primary)
                            }
                        }

                        Button(action: {
                            // Hook to real flow later
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Start Workout")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundStyle(DSColor.inverse)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(DSColor.accentSuccess)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .navigationTitle("Training")
                .scrollContentBackground(.hidden)
                .toolbarBackground(DSColor.barBackground, for: .navigationBar)
                .toolbarColorScheme(isDark ? .dark : nil, for: .navigationBar)
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .presentationBackground(DSColor.bg)
    }
}
