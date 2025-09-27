import Foundation
import SwiftUI

public enum PainArea: String, CaseIterable, Codable, Identifiable, Hashable {
    case back, neck, knees, shoulders, hips, wrists
    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .back: return "Back"
        case .neck: return "Neck"
        case .knees: return "Knees"
        case .shoulders: return "Shoulders"
        case .hips: return "Hips"
        case .wrists: return "Wrists"
        }
    }

    public var subtitle: String {
        switch self {
        case .back: return "Lower or upper back"
        case .neck: return "Neck tension or stiffness"
        case .knees: return "Knee pain or soreness"
        case .shoulders: return "Shoulder tension or pain"
        case .hips: return "Hip tightness or discomfort"
        case .wrists: return "Wrist pain or strain"
        }
    }

    public var iconName: String {
        switch self {
        case .back: return "figure.stand"
        case .neck: return "head.profile"
        case .knees: return "figure.walk"
        case .shoulders: return "figure.arms.open"
        case .hips: return "figure.flexibility"
        case .wrists: return "hand.raised"
        }
    }
}

public struct PainAssessment: Identifiable, Codable, Equatable, Hashable {
    public var id: UUID = UUID()
    public var area: PainArea
    public var date: Date = .now
    var severity: Int = 1
    var qualities: [PainQuality] = []
    var symptoms: [PainSymptom] = []
    var aggravatingFactors: [PainFactor] = []
    var relievingFactors: [PainReliefFactor] = []
    var functionalImpact: FunctionalImpact = .none
    var redFlags: [RedFlag] = []

    public init(area: PainArea, date: Date = .now, id: UUID = UUID()) {
        self.id = id
        self.area = area
        self.date = date
    }

    private enum CodingKeys: String, CodingKey {
        case id, area, date, severity, qualities, symptoms, aggravatingFactors, relievingFactors, functionalImpact, redFlags
    }
}

enum PainQuality: String, CaseIterable, Codable, Identifiable, Hashable {
    case aching, sharp, shooting, burning, throbbing, stabbing
    public var id: String { rawValue }

    var displayName: String {
        switch self {
        case .aching: return "Aching"
        case .sharp: return "Sharp"
        case .shooting: return "Shooting"
        case .burning: return "Burning"
        case .throbbing: return "Throbbing"
        case .stabbing: return "Stabbing"
        }
    }
}

enum PainSymptom: String, CaseIterable, Codable, Identifiable, Hashable {
    case stiffness, weakness, numbness, tingling, swelling, reducedRange
    public var id: String { rawValue }

    var displayName: String {
        switch self {
        case .stiffness: return "Stiffness"
        case .weakness: return "Weakness"
        case .numbness: return "Numbness"
        case .tingling: return "Tingling"
        case .swelling: return "Swelling"
        case .reducedRange: return "Reduced Range of Motion"
        }
    }
}

enum PainFactor: String, CaseIterable, Codable, Identifiable, Hashable {
    case movement, prolongedSitting, standing, lifting, bending, twisting
    public var id: String { rawValue }

    var displayName: String {
        switch self {
        case .movement: return "Movement"
        case .prolongedSitting: return "Prolonged Sitting"
        case .standing: return "Standing"
        case .lifting: return "Lifting"
        case .bending: return "Bending"
        case .twisting: return "Twisting"
        }
    }
}

enum PainReliefFactor: String, CaseIterable, Codable, Identifiable, Hashable {
    case rest, ice, heat, medication, stretching, massage
    public var id: String { rawValue }

    var displayName: String {
        switch self {
        case .rest: return "Rest"
        case .ice: return "Ice"
        case .heat: return "Heat"
        case .medication: return "Medication"
        case .stretching: return "Stretching"
        case .massage: return "Massage"
        }
    }
}

enum FunctionalImpact: String, CaseIterable, Codable, Identifiable, Hashable {
    case none, light, moderate, severe
    public var id: String { rawValue }

    var displayName: String {
        switch self {
        case .none: return "None"
        case .light: return "Light"
        case .moderate: return "Moderate"
        case .severe: return "Severe"
        }
    }
}

enum RedFlag: String, CaseIterable, Codable, Identifiable, Hashable {
    case severeTrauma, unexplainedWeightLoss, fever, nightPain, bowelBladderChanges, progressiveWeakness
    public var id: String { rawValue }

    var displayName: String {
        switch self {
        case .severeTrauma: return "Severe Trauma"
        case .unexplainedWeightLoss: return "Unexplained Weight Loss"
        case .fever: return "Fever"
        case .nightPain: return "Night Pain"
        case .bowelBladderChanges: return "Bowel/Bladder Changes"
        case .progressiveWeakness: return "Progressive Weakness"
        }
    }
}

struct PainAssessmentResult: Identifiable, Codable, Hashable {
    var id: UUID
    var assessment: PainAssessment
    var timestamp: Date
    var recommendations: [String]
    var riskLevel: RiskLevel

    init(id: UUID = .init(), assessment: PainAssessment, timestamp: Date = .init(), recommendations: [String] = [], riskLevel: RiskLevel = .low) {
        self.id = id
        self.assessment = assessment
        self.timestamp = timestamp
        self.recommendations = recommendations
        self.riskLevel = riskLevel
    }
}

enum RiskLevel: String, CaseIterable, Codable, Identifiable, Hashable {
    case low, medium, high
    public var id: String { rawValue }

    var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
}

struct PainAssessmentHistory: Codable {
    var assessments: [PainAssessmentResult] = []
    var lastSeverityByArea: [PainArea: Int] = [:]

    init() {
        self.assessments = []
        self.lastSeverityByArea = [:]
    }
}