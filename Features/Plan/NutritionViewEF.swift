import SwiftUI
import UIKit


// MARK: - Local theme + nav bar helpers (file-scoped)
fileprivate enum AppThemeUIV2 {
    static let canvas: Color = DSColor.canvas
    static let ctaNutrition: Color = DSColor.accentNutrition
    static let ctaPain: Color = EFColor.painAccent

    // risk badge colors (swap to DS tokens later if available)
    static let riskLow: Color = .green
    static let riskMed: Color = .orange
    static let riskHigh: Color = .red
}

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

// MARK: - Meal History View
fileprivate struct MealHistoryViewUIV2: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var journalStore: JournalStore
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(journalStore.meals.sorted(by: { $0.date > $1.date })) { entry in
                        MealHistoryCard(entry: entry)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .scrollContentBackground(.hidden)
            .background(semanticColors.page.ignoresSafeArea())
            .navigationTitle("Meal History")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color(semanticColors.page), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear { NavBlendLocal.apply() }
            .onDisappear { EFNavBarStyler.resetToDefault() }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

fileprivate struct MealHistoryCard: View {
    let entry: JournalMealEntry
    
    var body: some View {
        EFCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(entry.mealType.rawValue.capitalized)
                        .font(.headline)
                        .foregroundStyle(Color("TextPrimary"))
                    Spacer()
                    Text(entry.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(Color("TextSecondary"))
                }
                
                ForEach(entry.items) { item in
                    HStack {
                        Text(item.name)
                            .font(.subheadline)
                            .foregroundStyle(Color("TextPrimary"))
                        Spacer()
                        Text("\(item.calories ?? 0) cal")
                            .font(.caption)
                            .foregroundStyle(Color("TextSecondary"))
                    }
                }
            }
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

struct NutritionViewEF: View, Identifiable {
    let id = UUID()
    @EnvironmentObject private var journalStore: JournalStore
    @EnvironmentObject private var theme: EFThemeManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var nutrSelected: NUTRMealKind = .lunch
    @State private var nutrValues: [NUTRMealKind: NUTRMacros] =
        Dictionary(uniqueKeysWithValues: NUTRMealKind.allCases.map { ($0, .init()) })
    @State private var nutrNotes: String = ""
    @State private var showMealHistory = false
    @State private var showSmartLogSheet = false
    
    init() {
        // Navigation styling now handled by global EFNavBarStyler
    }

    private var nutrCurrent: Binding<NUTRMacros> {
        Binding(
            get: { nutrValues[nutrSelected, default: .init()] },
            set: { nutrValues[nutrSelected] = $0 }
        )
    }
    
    private func nutrStep(_ keyPath: WritableKeyPath<NUTRMacros, Int>, _ delta: Int) {
        var m = nutrValues[nutrSelected] ?? .init()
        m[keyPath: keyPath] = max(0, m[keyPath: keyPath] + delta)
        nutrValues[nutrSelected] = m
    }
    
    private var nutrCanLog: Bool {
        let m = nutrValues[nutrSelected] ?? .init()
        return !m.isEmpty || !nutrNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func nutrPersistCurrent() {
        let m = nutrValues[nutrSelected] ?? .init()
        let notes = nutrNotes.trimmingCharacters(in: .whitespacesAndNewlines)

        // Map to JournalMealType
        let journalMealType: JournalMealType
        switch nutrSelected {
        case .breakfast: journalMealType = .breakfast
        case .lunch:     journalMealType = .lunch
        case .dinner:    journalMealType = .dinner
        case .snack:     journalMealType = .snack
        }
        
        // Create food item
        let foodItem = JournalFoodItem(
            name: "Quick Entry",
            calories: m.calories,
            protein: Double(m.protein),
            carbs: Double(m.carbs),
            fat: Double(m.fat)
        )
        
        // Create meal entry
        let entry = JournalMealEntry(
            date: Date(),
            mealType: journalMealType,
            items: [foodItem]
        )
        
        // Persist to journal store
        journalStore.addMeal(entry)

        print("[NUTR] PERSIST -> \(nutrSelected.title) c:\(m.calories) p:\(m.protein) c:\(m.carbs) f:\(m.fat) notes:\(notes)")
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    var body: some View {
        let isDark = theme.isDark(colorScheme)
        return NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                        // Smart Log (AI) CTA
                        Button {
                            showSmartLogSheet = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(Color(hex: "FF9F0A"))
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Smart Log (AI)")
                                        .font(.headline)
                                        .foregroundStyle(Color(hex: "FFFFFF"))
                                    Text("Photo or text input")
                                        .font(.subheadline)
                                        .foregroundStyle(Color(hex: "A0A0A0"))
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 4)
                        
                        EFCard {
                            HStack(spacing: 12) {
                                Image(systemName: "fork.knife.circle.fill")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(Color(hex: "FF9F0A")) // Nutrition color
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Manual Log")
                                        .font(.headline)
                                        .efText(.primary)
                                    Text("Log food and macros")
                                        .font(.subheadline)
                                        .efText(.secondary)
                                }
                                Spacer()
                            }
                        }

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Type")
                                    .font(.subheadline)
                                    .efText(.secondary)
                                Picker("", selection: Binding(
                                    get: { nutrSelected.rawValue },
                                    set: { nutrSelected = NUTRMealKind(rawValue: $0) ?? .lunch }
                                )) {
                                    ForEach(NUTRMealKind.allCases) { meal in
                                        Text(meal.title)
                                            .tag(meal.rawValue)
                                            .efText(.primary)
                                    }
                                }
                                .pickerStyle(.segmented)

                                Stepper("Calories: \(nutrCurrent.wrappedValue.calories)", 
                                       value: Binding(
                                           get: { nutrCurrent.wrappedValue.calories },
                                           set: { nutrCurrent.wrappedValue.calories = $0 }
                                       ), 
                                       in: 0...2500, step: 50)
                                    .efText(.primary)
                                Stepper("Protein: \(nutrCurrent.wrappedValue.protein) g", 
                                       value: Binding(
                                           get: { nutrCurrent.wrappedValue.protein },
                                           set: { nutrCurrent.wrappedValue.protein = $0 }
                                       ), 
                                       in: 0...200, step: 5)
                                    .efText(.primary)
                                Stepper("Carbs: \(nutrCurrent.wrappedValue.carbs) g", 
                                       value: Binding(
                                           get: { nutrCurrent.wrappedValue.carbs },
                                           set: { nutrCurrent.wrappedValue.carbs = $0 }
                                       ), 
                                       in: 0...300, step: 5)
                                    .efText(.primary)
                                Stepper("Fat: \(nutrCurrent.wrappedValue.fat) g", 
                                       value: Binding(
                                           get: { nutrCurrent.wrappedValue.fat },
                                           set: { nutrCurrent.wrappedValue.fat = $0 }
                                       ), 
                                       in: 0...150, step: 5)
                                    .efText(.primary)
                            }
                        }

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Notes")
                                    .font(.subheadline)
                                    .efText(.secondary)
                                TextEditor(text: $nutrNotes)
                                    .frame(minHeight: 120)
                                    .scrollContentBackground(.hidden)
                                    .efText(.primary)
                            }
                        }

                        Button {
                            nutrPersistCurrent()
                            nutrValues[nutrSelected] = .init()
                            nutrNotes = ""
                        } label: {
                            Text("Log Meal")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                        .buttonStyle(.plain)
                        .background(nutrCanLog ? AppThemeUIV2.ctaNutrition : AppThemeUIV2.ctaNutrition.opacity(0.4))
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .disabled(!nutrCanLog)
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .scrollContentBackground(.hidden)
            .background(Color(hex: "0B0B0D").ignoresSafeArea())
            .toolbarBackground(isDark ? theme.tokens.darkBG : Color.clear, for: .navigationBar)
            .toolbarColorScheme(isDark ? .dark : nil, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle("Nutrition")
            .navigationBarTitleDisplayMode(.large)
            .onAppear { NavBlendLocal.apply() }
            .onDisappear { EFNavBarStyler.resetToDefault() }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showMealHistory = true
                    } label: {
                        Label("History", systemImage: "clock.arrow.circlepath")
                            .labelStyle(.titleAndIcon)
                    }
                    .tint(.primary)
                }
            }
            .sheet(isPresented: $showMealHistory) {
                MealHistoryViewUIV2()
                    .scrollContentBackground(.hidden)
                    .background(Color(hex: "0B0B0D").ignoresSafeArea())
                    .toolbarBackground(Color(hex: "111214"), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .onAppear { NavBlendLocal.apply() }
                    .onDisappear { EFNavBarStyler.resetToDefault() }
            }
            .sheet(isPresented: $showSmartLogSheet) {
                SmartMealLoggerSheet()
                    .environmentObject(journalStore)
            }
        }
    }
