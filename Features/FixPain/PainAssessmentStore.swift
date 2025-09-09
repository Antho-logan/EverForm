//
//  PainAssessmentStore.swift
//  EverForm
//
//  Local storage manager for pain assessment results
//

import SwiftUI

class PainAssessmentStore: ObservableObject {
    @Published private(set) var history: PainAssessmentHistory
    private let userDefaultsKey = "painAssessmentHistory"
    
    init() {
        self.history = Self.loadHistory()
    }
    
    // MARK: - Save Assessment
    func saveAssessment(_ result: PainAssessmentResult) {
        history.assessments.append(result)
        history.lastSeverityByArea[result.assessment.area] = result.assessment.severity
        saveHistory()
    }
    
    // MARK: - Get Recent Assessments
    func getRecentAssessments(for area: PainArea? = nil, limit: Int = 10) -> [PainAssessmentResult] {
        let assessments = area == nil ? 
            history.assessments : 
            history.assessments.filter { $0.assessment.area == area }
        
        return Array(assessments.sorted { $0.timestamp > $1.timestamp }.prefix(limit))
    }
    
    // MARK: - Get Last Severity
    func getLastSeverity(for area: PainArea) -> Int? {
        return history.lastSeverityByArea[area]
    }
    
    // MARK: - Clear History
    func clearHistory() {
        history = PainAssessmentHistory()
        saveHistory()
    }
    
    // MARK: - Private Methods
    private func saveHistory() {
        do {
            let data = try JSONEncoder().encode(history)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to save pain assessment history: \(error)")
        }
    }
    
    private static func loadHistory() -> PainAssessmentHistory {
        guard let data = UserDefaults.standard.data(forKey: "painAssessmentHistory") else {
            return PainAssessmentHistory()
        }
        
        do {
            return try JSONDecoder().decode(PainAssessmentHistory.self, from: data)
        } catch {
            print("Failed to load pain assessment history: \(error)")
            return PainAssessmentHistory()
        }
    }
}

// MARK: - Singleton Access
extension PainAssessmentStore {
    static let shared = PainAssessmentStore()
}