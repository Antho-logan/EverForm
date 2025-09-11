import SwiftUI
import UIKit


// MARK: - Local styling helpers (file-scoped, no new files)
fileprivate enum NUTRNavStylerLocal {
    static func apply(canvas: Color) {
        let ui = UIColor(canvas)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = ui
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

        let nav = UINavigationBar.appearance()
        nav.standardAppearance = appearance
        nav.scrollEdgeAppearance = appearance
        nav.compactAppearance = appearance
    }

    static func reset() {
        let a = UINavigationBarAppearance()
        a.configureWithDefaultBackground()
        let nav = UINavigationBar.appearance()
        nav.standardAppearance = a
        nav.scrollEdgeAppearance = a
        nav.compactAppearance = a
    }
}

// Disabled orange helper (same hue, lower alpha)
fileprivate extension Color {
    static var nutrCTA: Color { DSColor.accentNutrition }
    static var nutrCTADisabled: Color { DSColor.accentNutrition.opacity(0.4) }
}

// Tiny helper to convert SwiftUI Color -> UIColor
fileprivate extension UIColor {
    static func from(_ color: Color) -> UIColor {
        let view = UIHostingController(rootView: color).view
        view?.bounds = .init(x: 0, y: 0, width: 1, height: 1)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        let image = renderer.image { ctx in view?.drawHierarchy(in: CGRect(x: 0, y: 0, width: 1, height: 1), afterScreenUpdates: true) }
        return UIColor(patternImage: image)
    }
}

// MARK: - File-local nav bar styling (no stripe, matches canvas)
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

struct NutritionViewEF: View, Identifiable {
    let id = UUID()
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var journalStore: JournalStore
    @State private var nutrSelected: NUTRMealKind = .lunch
    @State private var nutrValues: [NUTRMealKind: NUTRMacros] =
        Dictionary(uniqueKeysWithValues: NUTRMealKind.allCases.map { ($0, .init()) })
    @State private var nutrNotes: String = ""
    @State private var showMealHistory = false
    @State private var showSmartLogSheet = false

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
        ZStack {
            Theme.Colors.efBackground
                .ignoresSafeArea()
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        // Smart Log (AI) CTA
                        Button {
                            showSmartLogSheet = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(.orange)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Smart Log (AI)")
                                        .font(.headline)
                                        .foregroundStyle(Color("TextPrimary"))
                                    Text("Photo or text input")
                                        .font(.subheadline)
                                        .foregroundStyle(Color("TextSecondary"))
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
                                    .foregroundStyle(.orange) // Nutrition color
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Manual Log")
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
                                Picker("", selection: Binding(
                                    get: { nutrSelected.rawValue },
                                    set: { nutrSelected = NUTRMealKind(rawValue: $0) ?? .lunch }
                                )) {
                                    ForEach(NUTRMealKind.allCases) { meal in
                                        Text(meal.title).tag(meal.rawValue)
                                    }
                                }
                                .pickerStyle(.segmented)

                                Stepper("Calories: \(nutrCurrent.wrappedValue.calories)", 
                                       value: Binding(
                                           get: { nutrCurrent.wrappedValue.calories },
                                           set: { nutrCurrent.wrappedValue.calories = $0 }
                                       ), 
                                       in: 0...2500, step: 50)
                                Stepper("Protein: \(nutrCurrent.wrappedValue.protein) g", 
                                       value: Binding(
                                           get: { nutrCurrent.wrappedValue.protein },
                                           set: { nutrCurrent.wrappedValue.protein = $0 }
                                       ), 
                                       in: 0...200, step: 5)
                                Stepper("Carbs: \(nutrCurrent.wrappedValue.carbs) g", 
                                       value: Binding(
                                           get: { nutrCurrent.wrappedValue.carbs },
                                           set: { nutrCurrent.wrappedValue.carbs = $0 }
                                       ), 
                                       in: 0...300, step: 5)
                                Stepper("Fat: \(nutrCurrent.wrappedValue.fat) g", 
                                       value: Binding(
                                           get: { nutrCurrent.wrappedValue.fat },
                                           set: { nutrCurrent.wrappedValue.fat = $0 }
                                       ), 
                                       in: 0...150, step: 5)
                            }
                        }

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Notes").font(.subheadline).foregroundStyle(Color("TextSecondary"))
                                TextEditor(text: $nutrNotes).frame(minHeight: 120)
                                    .scrollContentBackground(.hidden)
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
                        .background(nutrCanLog ? Color.nutrCTA : Color.nutrCTADisabled)
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .disabled(!nutrCanLog)
                        .padding(.horizontal, 16)
                    }
                  }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
                .navigationTitle("Nutrition")
                .navigationBarTitleDisplayMode(.large)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Theme.Colors.efBackground, for: .navigationBar)
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
                .onAppear {
                    NUTRNavStylerLocal.apply(canvas: Theme.Colors.efBackground)
                }
                .onDisappear {
                    NUTRNavStylerLocal.reset()
                }
                .sheet(isPresented: $showMealHistory) {
                    LoggedMealsView()
                        .environmentObject(journalStore)
                }
                .sheet(isPresented: $showSmartLogSheet) {
                    SmartMealLoggerSheet()
                        .environmentObject(journalStore)
                }
            }
        }
    }
