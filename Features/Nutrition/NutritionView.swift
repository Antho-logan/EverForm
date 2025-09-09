//
//  NutritionView.swift
//  EverForm
//
//  Nutrition feature page
//

import SwiftUI

struct NutritionView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var journalStore: JournalStore

    @State private var selectedMealType: JournalMealType = .breakfast
    @State private var selectedDate = Date()
    @State private var foodItems: [JournalFoodItem] = [JournalFoodItem()]
    @State private var showingSaveConfirmation = false
    @State private var autoFocusFood = false
    @State private var showLogMealSheet = false

    private let targetCalories = 2400 // Could come from profile store

    init(autoFocusFood: Bool = false) {
        self._autoFocusFood = State(initialValue: autoFocusFood)
    }

    var totalCalories: Int {
        foodItems.compactMap(\.calories).reduce(0, +)
    }

    var body: some View {
        let palette = Theme.palette(colorScheme)

        ScrollView {
            VStack(spacing: 16) {
                // Meal Section
                EFCard {
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        HStack {
                            Image(systemName: "fork.knife")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.orange)

                            Text("Meal")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(palette.textPrimary)

                            Spacer()
                        }

                        VStack(spacing: Theme.Spacing.md) {
                            // Meal Type
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Meal Type")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(palette.textSecondary)

                                Picker("Meal Type", selection: $selectedMealType) {
                                    ForEach(JournalMealType.allCases, id: \.self) { type in
                                        Text(type.rawValue).tag(type)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }

                            // Date & Time
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date & Time")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(palette.textSecondary)

                                DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                                    .datePickerStyle(.compact)
                            }
                        }
                    }
                }

                // Food Section
                EFCard {
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(.green)

                            Text("Food Items")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(palette.textPrimary)

                            Spacer()

                            Button(action: addFoodItem) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(palette.accent)
                            }
                            .accessibilityLabel("Add food item")
                        }

                        ForEach(foodItems.indices, id: \.self) { index in
                            FoodItemRow(
                                foodItem: $foodItems[index],
                                onDelete: { removeFoodItem(at: index) }
                            )
                        }

                        // Total calories display
                        HStack {
                            Text("Total Calories:")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(palette.textPrimary)

                            Spacer()

                            Text("\(totalCalories) / \(targetCalories)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(totalCalories > targetCalories ? .red : palette.accent)
                        }
                        .padding(.top, Theme.Spacing.sm)
                    }
                }

                // Action Button
                EFPillButton(
                    title: "Log Meal",
                    style: .primary,
                    color: .orange
                ) {
                    saveMeal()
                }
                .disabled(foodItems.allSatisfy { $0.name.isEmpty })

                // Quick Log Meal CTA Card (new feature)
                EFCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Quick Log Meal")
                                    .font(.headline)
                                    .foregroundStyle(DSColor.textPrimary)
                                Text("Fast meal logging with macro tracking")
                                    .font(.subheadline)
                                    .foregroundStyle(DSColor.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.orange)
                        }
                        
                        Button {
                            showLogMealSheet = true
                        } label: {
                            Text("Log Meal")
                                .font(.headline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.orange)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .padding(.top, 8)
                    }
                }

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(DSColor.appBackground.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Nutrition")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(DSColor.textPrimary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            .background(DSColor.appBackground)
        }
        .sheet(isPresented: $showLogMealSheet) {
            LogMealView()
        }
        .alert("Meal Logged!", isPresented: $showingSaveConfirmation) {
            Button("OK") { }
        } message: {
            Text("Your meal has been logged successfully.")
        }
    }

    // MARK: - Helper Methods

    private func addFoodItem() {
        foodItems.append(JournalFoodItem())
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    private func removeFoodItem(at index: Int) {
        foodItems.remove(at: index)
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    private func saveMeal() {
        let validFoodItems = foodItems.filter { !$0.name.isEmpty }

        let entry = JournalMealEntry(
            date: selectedDate,
            mealType: selectedMealType,
            items: validFoodItems
        )

        journalStore.addMeal(entry)
        showingSaveConfirmation = true

        // Reset form
        foodItems = [JournalFoodItem()]
    }
}

// MARK: - Food Item Row Component

private struct FoodItemRow: View {
    @Binding var foodItem: JournalFoodItem
    let onDelete: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let palette = Theme.palette(colorScheme)

        VStack(spacing: 12) {
            HStack {
                TextField("Food name", text: $foodItem.name)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 16, weight: .medium))

                Button(action: onDelete) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.red)
                }
                .frame(width: 44, height: 44)
                .accessibilityLabel("Remove food item")
            }

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Calories")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(palette.textSecondary)

                    TextField("0", value: $foodItem.calories, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .frame(width: 70)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Protein (g)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(palette.textSecondary)

                    TextField("0", value: $foodItem.protein, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                        .frame(width: 70)
                }

                Spacer()
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        NutritionView()
            .environmentObject(JournalStore())
    }
}
