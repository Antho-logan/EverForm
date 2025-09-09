//
//  PainModels.swift
//  EverForm
//
//  Data models for pain assessment and results
//

import SwiftUI

// MARK: - Pain Assessment Model
struct PainAssessment: Identifiable, Codable {
    let id = UUID()
    let area: PainArea
    let date: Date
    var subArea: PainSubArea?
    var severity: Int = 5 // 0-10 scale
    var onset: PainOnset = .today
    var duration: PainDuration = .lessThanWeek
    var qualities: [PainQuality] = []
    var symptoms: [PainSymptom] = []
    var aggravatingFactors: [PainFactor] = []
    var relievingFactors: [PainReliefFactor] = []
    var functionalImpact: FunctionalImpact = .none
    var redFlags: [RedFlag] = []
    var notes: String = ""
}

// MARK: - Pain Quality Types
enum PainQuality: String, CaseIterable, Identifiable, Codable {
    case sharp = "Sharp"
    case dullAching = "Dull/Aching"
    case throbbing = "Throbbing"
    case burning = "Burning"
    case tingling = "Tingling"
    case stiffness = "Stiffness"
    
    var id: String { rawValue }
}

// MARK: - Pain Symptom Types
enum PainSymptom: String, CaseIterable, Identifiable, Codable {
    case radiation = "Radiation (spreads from source)"
    case tinglingNumbness = "Tingling or numbness"
    case weakness = "Weakness"
    case none = "None of the above"
    
    var id: String { rawValue }
}

// MARK: - Pain Onset Types
enum PainOnset: String, CaseIterable, Identifiable, Codable {
    case today = "Today"
    case yesterday = "Yesterday"
    case thisWeek = "This week"
    case lastWeek = "Last week"
    case lastMonth = "Last month"
    case longer = "Longer than a month"
    
    var id: String { rawValue }
}

// MARK: - Pain Duration Types
enum PainDuration: String, CaseIterable, Identifiable, Codable {
    case today = "Today"
    case lessThanWeek = "Less than 1 week"
    case oneToSixWeeks = "1-6 weeks"
    case oneToThreeMonths = "1-3 months"
    case threeToSixMonths = "3-6 months"
    case moreThanSixMonths = "More than 6 months"
    
    var id: String { rawValue }
}

// MARK: - Pain Relief Factors
enum PainReliefFactor: String, CaseIterable, Identifiable, Codable {
    case rest = "Rest"
    case heat = "Heat therapy"
    case ice = "Ice therapy"
    case stretching = "Stretching"
    case massage = "Massage"
    case nsaids = "NSAIDs (ibuprofen, etc.)"
    case movement = "Gentle movement"
    case positionChange = "Position change"
    
    var id: String { rawValue }
}

// MARK: - Functional Impact Levels
enum FunctionalImpact: String, CaseIterable, Identifiable, Codable {
    case none = "No limitation"
    case light = "Light limitation"
    case hardToTrain = "Hard to train"
    case adlAffected = "Daily activities affected"
    
    var id: String { rawValue }
}

// MARK: - Red Flags
enum RedFlag: String, CaseIterable, Identifiable, Codable {
    case severeUnrelenting = "Severe, unrelenting pain"
    case fever = "Fever or chills"
    case majorTrauma = "Recent major trauma or accident"
    case progressiveWeakness = "Progressive weakness"
    case bladderBowel = "Bladder or bowel problems"
    case weightLoss = "Unexplained weight loss"
    case nightPain = "Pain that wakes you at night"
    case numbnessGroin = "Numbness in groin area"
    
    var id: String { rawValue }
}

// MARK: - Assessment Result
struct PainAssessmentResult: Identifiable, Codable {
    let id = UUID()
    let assessment: PainAssessment
    let classification: String
    let riskLevel: RiskLevel
    let suggestedBlocks: [PlanBlock]
    let timestamp: Date
    
    var hasRedFlags: Bool {
        !assessment.redFlags.isEmpty
    }
}

// MARK: - Risk Level
enum RiskLevel: String, CaseIterable, Identifiable, Codable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
    
    var id: String { rawValue }
}

// MARK: - Plan Block
struct PlanBlock: Identifiable, Codable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let timeFrame: TimeFrame
    let activities: [PlanActivity]
    
    var isUrgent: Bool {
        timeFrame == .today
    }
}

// MARK: - Time Frame
enum TimeFrame: String, CaseIterable, Identifiable, Codable {
    case today = "Today (10-15 min)"
    case fortyEightHours = "48-72 hours"
    case weekOne = "Week 1"
    case ongoing = "Ongoing"
    
    var id: String { rawValue }
}

// MARK: - Plan Activity
struct PlanActivity: Identifiable, Codable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let type: ActivityType
    let duration: String?
    let precautions: [String] = []
}

// MARK: - Activity Type
enum ActivityType: String, CaseIterable, Identifiable, Codable {
    case breathing = "Breathing"
    case mobility = "Mobility"
    case stability = "Stability"
    case posture = "Posture"
    case rest = "Rest"
    case heat = "Heat Therapy"
    case ice = "Ice Therapy"
    case stretching = "Stretching"
    
    var id: String { rawValue }
}

// MARK: - Stored Assessment History
struct PainAssessmentHistory: Codable {
    var assessments: [PainAssessmentResult] = []
    var lastSeverityByArea: [PainArea: Int] = [:]
}