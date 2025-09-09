//
//  NutritionView.swift
//  EverForm
//
//  Nutrition feature page
//

import SwiftUI
import UIKit

// MARK: - File-scoped helpers (prefixed to avoid collisions)
fileprivate enum NUTRMealKind: String, CaseIterable, Identifiable {
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

fileprivate struct NUTRMacros: Equatable {
    var calories = 0
    var protein  = 0
    var carbs    = 0
    var fat      = 0
    var isEmpty: Bool { calories == 0 && protein == 0 && carbs == 0 && fat == 0 }
}

fileprivate enum NUTRNavStyler {
    static func apply(background uiColor: UIColor) {
        let ap = UINavigationBarAppearance()
        ap.configureWithOpaqueBackground()
        ap.backgroundColor = uiColor
        ap.shadowColor = .clear
        ap.titleTextAttributes = [.foregroundColor: UIColor.label]
        ap.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        let nav = UINavigationBar.appearance()
        nav.standardAppearance   = ap
        nav.scrollEdgeAppearance = ap
        nav.compactAppearance    = ap
    }
}

struct NutritionView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var journalStore: JournalStore // ← ADAPT type name to the actual store

    // MARK: - Per-meal state
    @State private var nutrSelected: NUTRMealKind = .breakfast
    @State private var nutrValues: [NUTRMealKind: NUTRMacros] =
        Dictionary(uniqueKeysWithValues: NUTRMealKind.allCases.map { ($0, NUTRMacros()) })
    @State private var nutrNotes: String = ""

    // Computed binding to the current meal's macros
    private var nutrCurrent: Binding<NUTRMacros> {
        Binding(
            get: { nutrValues[nutrSelected, default: NUTRMacros()] },
            set: { nutrValues[nutrSelected] = $0 }
        )
    }

    private func nutrStep(_ keyPath: WritableKeyPath<NUTRMacros, Int>, _ delta: Int) {
        var m = nutrValues[nutrSelected] ?? NUTRMacros()
        m[keyPath: keyPath] = max(0, m[keyPath: keyPath] + delta)
        nutrValues[nutrSelected] = m
    }

    private var nutrCanLog: Bool {
        let m = nutrValues[nutrSelected] ?? .init()
        return !m.isEmpty || !nutrNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func nutrPersistCurrent() {
        let m = nutrValues[nutrSelected] ?? .init()
        let text = nutrNotes.trimmingCharacters(in: .whitespacesAndNewlines)

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
        switch nutrSelected {
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
                nutrMealCard
                nutrNotesCard

                Button {
                    nutrPersistCurrent()
                    // Reset only the active tab
                    nutrValues[nutrSelected] = .init()
                    nutrNotes = ""
                } label: {
                    Text("Log Meal")
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .disabled(!nutrCanLog)
                .opacity(nutrCanLog ? 1 : 0.4)
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
            NUTRNavStyler.apply(background: UIColor(DSColor.appBackground))
        }
    }

      // MARK: - UI Building Blocks
    
    private var nutrMealCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            nutrSegmented
            nutrMacroRow("Calories", value: nutrCurrent.wrappedValue.calories,
                         minus: { nutrStep(\.calories, -50) }, plus: { nutrStep(\.calories, +50) })
            nutrMacroRow("Protein",  value: nutrCurrent.wrappedValue.protein,
                         minus: { nutrStep(\.protein, -5) }, plus: { nutrStep(\.protein, +5) })
            nutrMacroRow("Carbs",    value: nutrCurrent.wrappedValue.carbs,
                         minus: { nutrStep(\.carbs, -5) }, plus: { nutrStep(\.carbs, +5) })
            nutrMacroRow("Fat",      value: nutrCurrent.wrappedValue.fat,
                         minus: { nutrStep(\.fat, -5) }, plus: { nutrStep(\.fat, +5) })
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(DSColor.card))
                .shadow(color: Color.black.opacity(0.06), radius: 8, y: 3)
        )
        .padding(.horizontal, 16)
    }

    private var nutrSegmented: some View {
        HStack(spacing: 8) {
            ForEach(NUTRMealKind.allCases) { kind in
                Button {
                    nutrSelected = kind
                } label: {
                    Text(kind.title)
                        .font(.callout.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(nutrSelected == kind ? Color(DSColor.card) 
                                                   : Color(DSColor.appBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color(DSColor.textSecondary).opacity(0.3), lineWidth: 1)
                        .opacity(nutrSelected == kind ? 0 : 1)
                )
                .foregroundStyle(nutrSelected == kind ? Color(DSColor.textPrimary) 
                                                      : Color(DSColor.textSecondary))
            }
        }
    }

    private func nutrMacroRow(_ title: String,
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

    private var nutrNotesCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notes").font(.headline)
            TextEditor(text: $nutrNotes)
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