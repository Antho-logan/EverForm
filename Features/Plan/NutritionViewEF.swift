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
        NavigationStack {
            Form {
                Section("Meal") {
                    Picker("Type", selection: $mealType) {
                        Text("Breakfast").tag("Breakfast")
                        Text("Lunch").tag("Lunch")
                        Text("Dinner").tag("Dinner")
                        Text("Snack").tag("Snack")
                    }
                    Stepper("Calories: \(calories)", value: $calories, in: 0...2500, step: 50)
                }
                Section("Macros") {
                    Stepper("Protein: \(protein)g", value: $protein, in: 0...200, step: 5)
                    Stepper("Carbs: \(carbs)g", value: $carbs, in: 0...300, step: 5)
                    Stepper("Fat: \(fat)g", value: $fat, in: 0...150, step: 5)
                }
                Section("Notes") {
                    TextEditor(text: $notes).frame(minHeight: 100)
                }
            }
            .tint(.orange) // Nutrition = orange
            .navigationTitle("Nutrition")
        }
    }
}
