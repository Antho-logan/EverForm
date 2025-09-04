import SwiftUI

struct RecoveryViewEF: View, Identifiable {
    let id = UUID()
    @State private var bedtime = Date()
    @State private var windDown: Int = 20
    @State private var breathwork = false
    @State private var stretching = false
    @State private var coldShower = false
    @State private var notes: String = ""

    var body: some View {
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
                                        .foregroundStyle(Color("TextPrimary"))
                                    Text("Wind-down and routines")
                                        .font(.subheadline)
                                        .foregroundStyle(Color("TextSecondary"))
                                }
                                Spacer()
                            }
                        }

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                DatePicker("Bedtime", selection: $bedtime, displayedComponents: .hourAndMinute)
                                Stepper("Wind-down: \(windDown) min", value: $windDown, in: 0...120, step: 5)
                                Toggle("Breathwork", isOn: $breathwork)
                                Toggle("Stretching", isOn: $stretching)
                                Toggle("Cold shower", isOn: $coldShower)
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
                .efScreenBackground()
            }
        }
    }
}
