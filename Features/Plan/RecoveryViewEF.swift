import SwiftUI

struct RecoveryViewEF: View, Identifiable {
    let id = UUID()
    @State private var bedtime = Date()
    @State private var windDown: Int = 20
    @State private var breathwork = false
    @State private var stretching = false
    @State private var coldShower = false
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
                                Image(systemName: "bed.double.fill")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(.blue) // Recovery color
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Sleep & Recovery")
                                        .font(.headline)
                                        .efText(.primary)
                                    Text("Wind-down and routines")
                                        .font(.subheadline)
                                        .efText(.secondary)
                                }
                                Spacer()
                            }
                        }

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                DatePicker("Bedtime", selection: $bedtime, displayedComponents: .hourAndMinute)
                                    .efText(.primary)
                                Stepper("Wind-down: \(windDown) min", value: $windDown, in: 0...120, step: 5)
                                    .efText(.primary)
                                Toggle("Breathwork", isOn: $breathwork)
                                    .efText(.primary)
                                Toggle("Stretching", isOn: $stretching)
                                    .efText(.primary)
                                Toggle("Cold shower", isOn: $coldShower)
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
                                Text("Save Recovery")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .navigationTitle("Recovery")
                .toolbarBackground(isDark ? theme.tokens.darkBG : Color.clear, for: .navigationBar)
                .toolbarColorScheme(isDark ? .dark : nil, for: .navigationBar)
                .efScreenBackground()
            }
        }
    }
}
