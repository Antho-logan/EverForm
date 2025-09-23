import SwiftUI

struct NutritionDetailView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                HStack(spacing: 10) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.orange)  // Nutrition accent
                    Text("Nutrition")
                        .font(.largeTitle.bold())
                        .foregroundStyle(DSColor.textPrimary)
                    Spacer()
                }
                .padding(.horizontal, 4)

                EFCard {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Today").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                            Text("1,850 / 2,661 kcal")
                                .font(.title3.bold()).foregroundStyle(DSColor.textPrimary)
                        }
                        Spacer()
                        Button("Log Meal") { /* hook later */ }
                            .buttonStyle(.borderedProminent)
                            .tint(.orange)
                    }
                }

                EFCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Macros").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        HStack {
                            Label("Protein 120g", systemImage: "chart.bar.fill")
                            Spacer()
                            Label("Carbs 240g", systemImage: "chart.bar.fill")
                            Spacer()
                            Label("Fat 70g", systemImage: "chart.bar.fill")
                        }
                        .foregroundStyle(.orange)
                        .font(.callout)
                    }
                }

                EFCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recent Meals").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        ForEach(["Chicken bowl", "Greek yogurt", "Oats & berries"], id: \.self) { m in
                            HStack { Text(m); Spacer(); Image(systemName: "chevron.right") }
                                .foregroundStyle(DSColor.textPrimary)
                                .padding(.vertical, 6)
                        }
                    }
                }

            }.padding(16)
        }
        .background(DSColor.bg.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}


