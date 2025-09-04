import SwiftUI

struct NutritionViewEF: View, Identifiable {
    let id = UUID()
    @State private var mealType: String = "Lunch"
    @State private var calories: Int = 650
    @State private var protein: Int = 35
    @State private var carbs: Int = 60
    @State private var fat: Int = 20
    @State private var notes: String = ""

    var body: some View {
        ZStack {
            Color("AppBackground").ignoresSafeArea()
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        EFCard {
                            HStack(spacing: 12) {
                                Image(systemName: "fork.knife.circle.fill")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(.orange) // Nutrition color
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Meal")
                                        .font(.headline)
                                        .foregroundStyle(Color("TextPrimary"))
                                    Text("Log food and macros")
                                        .font(.subheadline)
                                        .foregroundStyle(Color("TextSecondary"))
                                }
                                Spacer()
                            }
                        }

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Type").font(.subheadline).foregroundStyle(Color("TextSecondary"))
                                Picker("", selection: $mealType) {
                                    Text("Breakfast").tag("Breakfast")
                                    Text("Lunch").tag("Lunch")
                                    Text("Dinner").tag("Dinner")
                                    Text("Snack").tag("Snack")
                                }
                                .pickerStyle(.segmented)

                                Stepper("Calories: \(calories)", value: $calories, in: 0...2500, step: 50)
                                Stepper("Protein: \(protein) g", value: $protein, in: 0...200, step: 5)
                                Stepper("Carbs: \(carbs) g", value: $carbs, in: 0...300, step: 5)
                                Stepper("Fat: \(fat) g", value: $fat, in: 0...150, step: 5)
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
                                Text("Log Meal")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .navigationTitle("Nutrition")
                .toolbarBackground(.clear, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
}
