import SwiftUI

extension PainArea {
    /// SF Symbol name for each pain area, used by Fix Pain tiles.
    /// Keep these simple for now—goal is to satisfy `area.icon` references.
    var icon: String {
        switch self {
        case .back:
            return "figure.strengthtraining.traditional" // alt: "figure.arms.open"
        case .neck:
            return "person.fill.questionmark"            // attention at head/neck
        case .knees:
            return "figure.run"
        case .shoulders:
            return "figure.walk"
        case .hips:
            return "figure.cooldown"                     // reasonable generic body symbol
        case .wrists:
            return "hand.raised"
        }
    }
}