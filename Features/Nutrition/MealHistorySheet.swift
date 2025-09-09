import SwiftUI

struct MealHistorySheet: View {
    @EnvironmentObject var journalStore: JournalStore
    @Environment(\.dismiss) private var dismiss

    private var mealsToday: [JournalMealEntry] {
        return journalStore.todaysMeals.sorted(by: { $0.date > $1.date })
    }

    var body: some View {
        NavigationStack {
            List {
                if mealsToday.isEmpty {
                    Section {
                        VStack(alignment: .center, spacing: 12) {
                            Text("No meals logged today")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Text("Log a meal to see it here.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 24)
                    }
                } else {
                    ForEach(mealsToday) { meal in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(meal.mealType.rawValue)
                                    .font(.headline)
                                Spacer()
                                Text("\(meal.totalCalories) kcal")
                                    .font(.headline)
                            }
                            .foregroundStyle(.primary)

                            HStack(spacing: 12) {
                                Text("P \(Int(meal.totalProtein))g")
                                Text("C \(Int(meal.totalCarbs))g")
                                Text("F \(Int(meal.totalFat))g")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)

                            if !meal.items.isEmpty {
                                Text(meal.items.map { $0.name }.joined(separator: ", "))
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .padding(.top, 2)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let entry = mealsToday[index]
                            journalStore.removeMeal(entry)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Meal History")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { 
                    Button("Done") { dismiss() } 
                }
            }
            .background(DSColor.appBackground)
        }
    }
}