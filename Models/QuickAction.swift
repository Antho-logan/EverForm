//
//  QuickAction.swift
//  EverForm
//
//  Quick action model for reorderable tiles
//

import SwiftUI

struct QuickAction: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let icon: String
    let colorName: String
    let actionType: ActionType
    
    enum ActionType: String, Codable, CaseIterable {
        case addWater = "addWater"
        case breathwork = "breathwork"
        case fixPain = "fixPain"
        case lookMaxing = "lookMaxing"
    }
    
    // Custom Color coding for persistence
    enum CodingKeys: String, CodingKey {
        case id, title, icon, actionType, colorName
    }

    init(id: UUID, title: String, icon: String, colorName: String, actionType: ActionType) {
        self.id = id
        self.title = title
        self.icon = icon
        self.colorName = colorName
        self.actionType = actionType
    }

    var color: Color {
        switch colorName {
        case "accentRecovery": return DSColor.accentRecovery
        case "accentSuccess": return DSColor.accentSuccess
        case "accentDanger": return DSColor.accentDanger
        case "accentMobility": return DSColor.accentMobility
        default: return DSColor.accentSuccess
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        icon = try container.decode(String.self, forKey: .icon)
        actionType = try container.decode(ActionType.self, forKey: .actionType)
        colorName = try container.decode(String.self, forKey: .colorName)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(icon, forKey: .icon)
        try container.encode(actionType, forKey: .actionType)
        try container.encode(colorName, forKey: .colorName)
    }
    
    static let defaultActions: [QuickAction] = [
        QuickAction(
            id: UUID(),
            title: "Add Water",
            icon: "drop.fill",
            colorName: "accentRecovery",
            actionType: .addWater
        ),
        QuickAction(
            id: UUID(),
            title: "Breathwork",
            icon: "wind",
            colorName: "accentSuccess",
            actionType: .breathwork
        ),
        QuickAction(
            id: UUID(),
            title: "Fix Pain",
            icon: "cross.case.fill",
            colorName: "accentDanger",
            actionType: .fixPain
        ),
        QuickAction(
            id: UUID(),
            title: "Look Maxing",
            icon: "person.fill.viewfinder",
            colorName: "accentMobility",
            actionType: .lookMaxing
        )
    ]
}

// MARK: - Routing Helper
extension QuickAction {
    var route: EFRoute? {
        switch actionType {
        case .addWater:
            return nil // Local action, no navigation
        case .breathwork:
            return .breathwork
        case .fixPain:
            return .fixPain
        case .lookMaxing:
            return .lookMaxing
        }
    }
}

// MARK: - Color Extensions
// Color extensions moved to DesignSystem.swift to avoid duplicates
