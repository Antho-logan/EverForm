//
//  NutritionView.swift
//  EverForm
//
//  Nutrition feature page
//

import SwiftUI
import UIKit

// MARK: - Header blend (remove the hairline/stripe under the nav bar)
fileprivate enum NutritionNavStyler {
    static func apply(background uiColor: UIColor) {
        let ap = UINavigationBarAppearance()
        ap.configureWithOpaqueBackground()
        ap.backgroundColor = uiColor
        ap.shadowColor = .clear // << removes the hairline
        ap.titleTextAttributes = [.foregroundColor: UIColor.label]
        ap.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

        let nav = UINavigationBar.appearance()
        nav.standardAppearance = ap
        nav.scrollEdgeAppearance = ap
        nav.compactAppearance = ap
    }
}

// MARK: - Local per-meal state types (use real app types if they exist)
fileprivate enum MealKindLocal: String, CaseIterable, Identifiable {
    case breakfast, lunch, dinner, snack
    var id: String { rawValue }
    var title: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch:     return "Lunch"
        case .dinner:    return "Dinner"
        case .snack:     return "Snack"
        }
    }
}

fileprivate struct MacroInput: Equatable {
    var calories: Int = 0
    var protein:  Int = 0
    var carbs:    Int = 0
    var fat:      Int = 0
    var isEmpty: Bool { calories == 0 && protein == 0 && carbs == 0 && fat == 0 }
}

struct NutritionView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var journalStore: JournalStore // ← ADAPT type name to the actual store

    @State private var selectedMeal: MealKindLocal = .lunch
    @State private var inputs: [MealKindLocal: MacroInput] =
        .init(uniqueKeysWithValues: MealKindLocal.allCases.map { ($0, MacroInput()) })
    @State private var notes: String = ""
    @State private var selectedDate = Date()
    @State private var showLogMealSheet = false

    // Use the same background token your app already uses
    private var canvasColor: Color {
        // Prefer existing tokens if present in the app (adjust to match your codebase)
        // e.g. EFTheme.Colors.canvas or DSColor.appBackground
        DSColor.appBackground
    }

    // Enable only when there's something to log
    private var canLog: Bool {
        let m = inputs[selectedMeal] ?? MacroInput()
        return !m.isEmpty || !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // Type selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Type").font(.headline)
                    SegmentedMealSelector(selection: $selectedMeal, items: MealKindLocal.allCases)
                }
                .padding()
                .background(.white.opacity(0.95), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(color: .black.opacity(0.07), radius: 8, y: 2)

                // Macro rows (each is bound into the per-meal dictionary)
                MacroRow(title: "Calories", value: binding(\.calories), step: 50)
                MacroRow(title: "Protein",  value: binding(\.protein),  step: 5, suffix: "g")
                MacroRow(title: "Carbs",    value: binding(\.carbs),    step: 5, suffix: "g")
                MacroRow(title: "Fat",      value: binding(\.fat),      step: 5, suffix: "g")

                // Notes
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes").font(.headline)
                    TextEditor(text: $notes)
                        .frame(minHeight: 120)
                        .padding(12)
                        .background(.white, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }

                // CTA
                Button(action: logMeal) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Log Meal").fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                }
                .buttonStyle(.plain)
                .foregroundColor(.white)
                .background((canLog ? Color.orange : Color.orange.opacity(0.4)), in: Capsule())
                .disabled(!canLog)
                .padding(.top, 8)

                // Advanced Log CTA Card (legacy feature)
                EFCard {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Advanced Meal Logging")
                                    .font(.headline)
                                    .foregroundStyle(DSColor.textPrimary)
                                Text("Multiple food items with detailed tracking")
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
                            Text("Advanced Log")
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
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        // Make the header blend and remove the stripe
        .background(canvasColor.ignoresSafeArea())
        .navigationTitle("Nutrition")
        .toolbarBackground(canvasColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            NutritionNavStyler.apply(background: UIColor(canvasColor))
        }
        .sheet(isPresented: $showLogMealSheet) {
            LogMealView()
        }
    }

    // Binding into a single meal slot inside our dictionary
    private func binding(_ keyPath: WritableKeyPath<MacroInput, Int>) -> Binding<Int> {
        Binding {
            inputs[selectedMeal, default: MacroInput()][keyPath: keyPath]
        } set: { newValue in
            var copy = inputs[selectedMeal, default: MacroInput()]
            copy[keyPath: keyPath] = max(0, newValue)
            inputs[selectedMeal] = copy
        }
    }

    // Persist the meal (adapt to the real store) and reset the current tab
    private func logMeal() {
        let m = inputs[selectedMeal, default: MacroInput()]
        
        // Convert to the app's real JournalMealEntry model
        let foodItem = JournalFoodItem(
            name: "Quick Entry",
            calories: m.calories,
            protein: Double(m.protein),
            carbs: Double(m.carbs),
            fat: Double(m.fat)
        )
        
        // Map local meal type to JournalMealType
        let journalMealType: JournalMealType
        switch selectedMeal {
        case .breakfast: journalMealType = .breakfast
        case .lunch: journalMealType = .lunch
        case .dinner: journalMealType = .dinner
        case .snack: journalMealType = .snack
        }
        
        let entry = JournalMealEntry(
            date: selectedDate,
            mealType: journalMealType,
            items: [foodItem]
        )
        
        // ADAPT this call to the actual store method in your codebase.
        journalStore.addMeal(entry)

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        // Reset only the current tab's values (keep others)
        inputs[selectedMeal] = MacroInput()
        notes = ""
    }
}

// MARK: - Segmented control
fileprivate struct SegmentedMealSelector: View {
    @Binding var selection: MealKindLocal
    let items: [MealKindLocal]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                Button {
                    selection = item
                } label: {
                    Text(item.title)
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selection == item ? Color.white : Color.white.opacity(0.55))
                }
                .buttonStyle(.plain)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.06)))
            }
        }
        .background(Color.white.opacity(0.4), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// MARK: - Macro row (± steppers)
fileprivate struct MacroRow: View {
    let title: String
    @Binding var value: Int
    var step: Int = 1
    var suffix: String = ""

    init(title: String, value: Binding<Int>, step: Int = 1, suffix: String = "") {
        self.title = title
        self._value = value
        self.step = max(1, step)
        self.suffix = suffix
    }

    var body: some View {
        HStack {
            Text("\(title): \(value)\(suffix.isEmpty ? "" : " \(suffix)")")
                .font(.body)
            Spacer(minLength: 12)
            HStack(spacing: 8) {
                Button { value = max(0, value - step) } label: {
                    Image(systemName: "minus")
                        .frame(width: 44, height: 36)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.06)))
                }.buttonStyle(.plain)
                Button { value += step } label: {
                    Image(systemName: "plus")
                        .frame(width: 44, height: 36)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.06)))
                }.buttonStyle(.plain)
            }
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 8, y: 2)
    }
}

// MARK: - Legacy Food Item Row Component (kept for Advanced Log)

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