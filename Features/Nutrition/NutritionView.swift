//
//  NutritionView.swift
//  EverForm
//
//  Nutrition feature page
//

import SwiftUI
import UIKit

// MARK: - Local Nutrition helpers (file-scoped, no project-wide changes)
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

fileprivate struct MacrosLocal: Equatable {
    var calories: Int = 0
    var protein:  Int = 0
    var carbs:    Int = 0
    var fat:      Int = 0
    
    var isEmpty: Bool { calories == 0 && protein == 0 && carbs == 0 && fat == 0 }
}

// Header styling to remove the faint separator/stripe and match app background.
fileprivate enum NutritionNavStyler {
    static func apply(background uiColor: UIColor) {
        let ap = UINavigationBarAppearance()
        ap.configureWithOpaqueBackground()
        ap.backgroundColor = uiColor
        ap.shadowColor = .clear
        ap.titleTextAttributes = [.foregroundColor: UIColor.label]
        ap.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        let nav = UINavigationBar.appearance()
        nav.standardAppearance = ap
        nav.scrollEdgeAppearance = ap
        nav.compactAppearance = ap
    }
}

struct NutritionView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var journalStore: JournalStore // ← ADAPT type name to the actual store

    // MARK: - Per-meal state
    @State private var selectedMealLocal: MealKindLocal = .breakfast
    @State private var mealValuesLocal: [MealKindLocal: MacrosLocal] =
        Dictionary(uniqueKeysWithValues: MealKindLocal.allCases.map { ($0, MacrosLocal()) })
    @State private var notesLocal: String = ""

    // Computed binding to the current meal's macros
    private var currentMacrosLocal: Binding<MacrosLocal> {
        Binding(
            get: { mealValuesLocal[selectedMealLocal, default: MacrosLocal()] },
            set: { mealValuesLocal[selectedMealLocal] = $0 }
        )
    }

    private func step(_ keyPath: WritableKeyPath<MacrosLocal, Int>, _ delta: Int) {
        var m = mealValuesLocal[selectedMealLocal] ?? MacrosLocal()
        m[keyPath: keyPath] = max(0, m[keyPath: keyPath] + delta)
        mealValuesLocal[selectedMealLocal] = m
    }

    private var canLogLocal: Bool {
        let m = mealValuesLocal[selectedMealLocal] ?? .init()
        return !m.isEmpty || !notesLocal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func persistCurrentMealLocal() {
        let m = mealValuesLocal[selectedMealLocal] ?? .init()
        _ = notesLocal.trimmingCharacters(in: .whitespacesAndNewlines)

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
        switch selectedMealLocal {
        case .breakfast: journalMealType = .breakfast
        case .lunch: journalMealType = .lunch
        case .dinner: journalMealType = .dinner
        case .snack: journalMealType = .snack
        }
        
        let entry = JournalMealEntry(
            date: Date(),
            mealType: journalMealType,
            items: [foodItem]
        )
        
        // Call the real store method
        journalStore.addMeal(entry)

        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                mealCardLocal
                notesCardLocal

                Button {
                    persistCurrentMealLocal()
                    // Reset only the active tab
                    mealValuesLocal[selectedMealLocal] = .init()
                    notesLocal = ""
                } label: {
                    Text("Log Meal")
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .disabled(!canLogLocal)
                .opacity(canLogLocal ? 1 : 0.4)
                .buttonStyle(.borderedProminent)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

                #if DEBUG
                // DEBUG watermark so we know we're editing the right screen
                Text("Nutrition • \(Date.now.formatted(.dateTime.year().month().day().hour().minute()))")
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
                #endif
            }
            .padding(.top, 8)
        }
        .navigationTitle("Nutrition")
        .navigationBarTitleDisplayMode(.large)
        // Blend header with page background and remove stripe
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(DSColor.appBackground), for: .navigationBar)
        .onAppear {
            NutritionNavStyler.apply(background: UIColor(DSColor.appBackground))
        }
    }

      // MARK: - UI Building Blocks
    
    private var mealCardLocal: some View {
        VStack(alignment: .leading, spacing: 12) {
            segmentedLocal
            macroRowLocal("Calories", value: currentMacrosLocal.wrappedValue.calories,
                         minus: { step(\.calories, -50) }, plus: { step(\.calories, +50) })
            macroRowLocal("Protein",  value: currentMacrosLocal.wrappedValue.protein,
                         minus: { step(\.protein, -5) }, plus: { step(\.protein, +5) })
            macroRowLocal("Carbs",    value: currentMacrosLocal.wrappedValue.carbs,
                         minus: { step(\.carbs, -5) }, plus: { step(\.carbs, +5) })
            macroRowLocal("Fat",      value: currentMacrosLocal.wrappedValue.fat,
                         minus: { step(\.fat, -5) }, plus: { step(\.fat, +5) })
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(DSColor.card))
                .shadow(color: Color.black.opacity(0.06), radius: 8, y: 3)
        )
        .padding(.horizontal, 16)
    }

    private var segmentedLocal: some View {
        HStack(spacing: 8) {
            ForEach(MealKindLocal.allCases) { kind in
                Button {
                    selectedMealLocal = kind
                } label: {
                    Text(kind.title)
                        .font(.callout.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(selectedMealLocal == kind ? Color(DSColor.card) 
                                                      : Color(DSColor.appBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color(DSColor.textSecondary).opacity(0.3), lineWidth: 1)
                        .opacity(selectedMealLocal == kind ? 0 : 1)
                )
                .foregroundStyle(selectedMealLocal == kind ? Color(DSColor.textPrimary) 
                                                         : Color(DSColor.textSecondary))
            }
        }
    }

    private func macroRowLocal(_ title: String,
                           value: Int,
                           minus: @escaping () -> Void,
                           plus:  @escaping () -> Void) -> some View {
        HStack {
            Text("\(title): \(value)\(title == "Calories" ? "" : " g")")
            Spacer()
            HStack(spacing: 10) {
                Button(action: minus) { Image(systemName: "minus") }.buttonStyle(.bordered)
                Button(action: plus)  { Image(systemName: "plus")  }.buttonStyle(.bordered)
            }
        }
        .font(.body)
    }

    private var notesCardLocal: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes").font(.headline)
            TextEditor(text: $notesLocal)
                .frame(minHeight: 120)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(DSColor.appBackground))
                )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(DSColor.card))
                .shadow(color: Color.black.opacity(0.06), radius: 8, y: 3)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    NavigationStack {
        NutritionView()
            .environmentObject(JournalStore())
    }
}