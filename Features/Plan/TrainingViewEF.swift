import SwiftUI

struct TrainingViewEF: View, Identifiable {
    let id = UUID()
    @State private var selectedType: String = "Strength"
    @State private var duration: Int = 45
    @State private var notes: String = ""

    var body: some View {
        ZStack {
            Color("AppBackground").ignoresSafeArea()
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        EFCard {
                            HStack(spacing: 12) {
                                Image(systemName: "dumbbell.fill")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(.green)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Session")
                                        .font(.headline)
                                        .foregroundStyle(Color("TextPrimary"))
                                    Text("Set up your training session")
                                        .font(.subheadline)
                                        .foregroundStyle(Color("TextSecondary"))
                                }
                                Spacer()
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.snappy(duration: 0.25), value: selectedType)

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Type")
                                    .font(.subheadline).foregroundStyle(Color("TextSecondary"))
                                Picker("", selection: $selectedType) {
                                    Text("Strength").tag("Strength")
                                    Text("Cardio").tag("Cardio")
                                    Text("HIIT").tag("HIIT")
                                    Text("Mobility").tag("Mobility")
                                }
                                .pickerStyle(.segmented)

                                Stepper("Duration: \(duration) min", value: $duration, in: 5...180, step: 5)
                                    .font(.body)
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
                                Image(systemName: "play.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Start Workout")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(.green)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .navigationTitle("Training")
                .toolbarBackground(.clear, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
}
