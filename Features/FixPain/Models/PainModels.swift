import Foundation

// MARK: - Pain Area
public enum PainArea: String, CaseIterable, Codable, Identifiable, Hashable {
    case back, neck, knees, shoulders, hips, wrists

    public var id: String { rawValue }

    // MARK: - Sub Area
    public enum SubArea: String, CaseIterable, Codable, Identifiable, Hashable {
        case upper, lower, left, right, center, front, back, medial, lateral, general

        public var id: String { rawValue }

        public var name: String {
            switch self {
            case .upper: return "Upper"
            case .lower: return "Lower"
            case .left: return "Left"
            case .right: return "Right"
            case .center: return "Center"
            case .front: return "Front"
            case .back: return "Back"
            case .medial: return "Medial"
            case .lateral: return "Lateral"
            case .general: return "General"
            }
        }
    }
}

// MARK: - Pain Onset
public enum PainOnset: String, Codable, CaseIterable {
    case sudden = "Sudden"
    case gradual = "Gradual"
    case unknown = "Unknown"
}

// MARK: - Pain Assessment
public struct PainAssessment: Identifiable, Codable, Equatable, Hashable {
    public let id: UUID
    public let area: PainArea
    public let createdAt: Date

    public init(id: UUID = UUID(), area: PainArea, createdAt: Date = Date()) {
        self.id = id
        self.area = area
        self.createdAt = createdAt
    }

    private enum CodingKeys: String, CodingKey {
        case id, area, createdAt
    }
}