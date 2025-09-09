//
//  MealModels.swift
//  EverForm
//
//  Meal models and local storage for nutrition logging
//

import Foundation
import Combine

enum EFMealType: String, Codable, CaseIterable, Identifiable {
    case breakfast, lunch, dinner, snack
    var id: String { rawValue }
    var title: String { rawValue.capitalized }
    var emoji: String {
        switch self {
        case .breakfast: return "🍳"
        case .lunch:     return "🥗"
        case .dinner:    return "🍽️"
        case .snack:     return "🍎"
        }
    }
}

struct EFFoodItem: Identifiable, Codable {
    var id = UUID()
    var name: String = ""
    var grams: Double = 0
    var kcal: Double = 0
    var protein: Double = 0
    var carbs: Double = 0
    var fat: Double = 0
}

struct EFMeal: Identifiable, Codable {
    var id = UUID()
    var type: EFMealType
    var date: Date = Date()
    var items: [EFFoodItem] = []
    var notes: String? = nil
    
    var totalKcal: Double { items.reduce(0) { $0 + max(0, $1.kcal) } }
    var totalProtein: Double { items.reduce(0) { $0 + max(0, $1.protein) } }
    var totalCarbs: Double { items.reduce(0) { $0 + max(0, $1.carbs) } }
    var totalFat: Double { items.reduce(0) { $0 + max(0, $1.fat) } }
}

final class EFMealStore: ObservableObject {
    static let shared = EFMealStore()
    @Published private(set) var meals: [EFMeal] = [] {
        didSet { persist(); NotificationCenter.default.post(name: .EFMealsDidChange, object: nil) }
    }
    private let key = "EFMealStore.v1"
    private init() { load() }
    
    func add(_ meal: EFMeal) { meals.insert(meal, at: 0) }
    func remove(_ id: EFMeal.ID) { meals.removeAll { $0.id == id } }
    func meals(on day: Date) -> [EFMeal] {
        let cal = Calendar.current
        return meals.filter { cal.isDate($0.date, inSameDayAs: day) }
    }
    
    private func persist() {
        guard let data = try? JSONEncoder().encode(meals) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([EFMeal].self, from: data) else { return }
        meals = saved
    }
}

extension Notification.Name {
    static let EFMealsDidChange = Notification.Name("EFMealsDidChange")
}