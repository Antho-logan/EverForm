//
//  PainArea.swift
//  EverForm
//
//  Pain area enumeration with sub-areas and configurations
//

import SwiftUI

enum PainArea: String, CaseIterable, Identifiable, Codable {
    case back = "Back"
    case neck = "Neck"
    case knees = "Knees"
    case shoulders = "Shoulders"
    case hips = "Hips"
    case wrists = "Wrists"
    
    var id: String { rawValue }
    
    // Icon for each area
    var iconName: String {
        switch self {
        case .back: return "figure.stand"
        case .neck: return "head.profile"
        case .knees: return "figure.walk"
        case .shoulders: return "figure.arms.open"
        case .hips: return "figure.flexibility"
        case .wrists: return "hand.raised"
        }
    }
    
    // Description for each area
    var description: String {
        switch self {
        case .back: return "Lower or upper back discomfort"
        case .neck: return "Neck tension or stiffness"
        case .knees: return "Knee pain or soreness"
        case .shoulders: return "Shoulder tension or pain"
        case .hips: return "Hip tightness or discomfort"
        case .wrists: return "Wrist pain or strain"
        }
    }
    
    // Sub-areas for detailed location selection
    var subAreas: [PainSubArea] {
        switch self {
        case .back:
            return [
                PainSubArea(id: "upper", name: "Upper Back"),
                PainSubArea(id: "mid", name: "Mid Back"),
                PainSubArea(id: "lower", name: "Lower Back")
            ]
        case .neck:
            return [
                PainSubArea(id: "front", name: "Front Neck"),
                PainSubArea(id: "sides", name: "Sides of Neck"),
                PainSubArea(id: "back", name: "Back of Neck")
            ]
        case .knees:
            return [
                PainSubArea(id: "front", name: "Front of Knee"),
                PainSubArea(id: "back", name: "Back of Knee"),
                PainSubArea(id: "sides", name: "Sides of Knee")
            ]
        case .shoulders:
            return [
                PainSubArea(id: "front", name: "Front Shoulder"),
                PainSubArea(id: "top", name: "Top of Shoulder"),
                PainSubArea(id: "back", name: "Back Shoulder")
            ]
        case .hips:
            return [
                PainSubArea(id: "front", name: "Front Hip"),
                PainSubArea(id: "side", name: "Side Hip"),
                PainSubArea(id: "back", name: "Back Hip")
            ]
        case .wrists:
            return [
                PainSubArea(id: "palm", name: "Palm Side"),
                PainSubArea(id: "back", name: "Back Side"),
                PainSubArea(id: "thumb", name: "Thumb Side")
            ]
        }
    }
    
    // Aggravating factors specific to each area
    var aggravatingFactors: [PainFactor] {
        switch self {
        case .back:
            return [
                PainFactor(id: "bending", name: "Bending forward"),
                PainFactor(id: "standing", name: "Standing for long periods"),
                PainFactor(id: "sitting", name: "Sitting for long periods"),
                PainFactor(id: "lifting", name: "Lifting heavy objects"),
                PainFactor(id: "twisting", name: "Twisting movements")
            ]
        case .neck:
            return [
                PainFactor(id: "looking_down", name: "Looking down at phone"),
                PainFactor(id: "rotation", name: "Head rotation"),
                PainFactor(id: "sleeping", name: "Sleeping position"),
                PainFactor(id: "computer", name: "Computer work"),
                PainFactor(id: "driving", name: "Driving")
            ]
        case .knees:
            return [
                PainFactor(id: "stairs", name: "Going up/down stairs"),
                PainFactor(id: "squats", name: "Squatting"),
                PainFactor(id: "running", name: "Running"),
                PainFactor(id: "jumping", name: "Jumping"),
                PainFactor(id: "kneeling", name: "Kneeling")
            ]
        case .shoulders:
            return [
                PainFactor(id: "reaching", name: "Reaching overhead"),
                PainFactor(id: "lifting", name: "Lifting objects"),
                PainFactor(id: "pushing", name: "Pushing movements"),
                PainFactor(id: "throwing", name: "Throwing motions"),
                PainFactor(id: "sleeping", name: "Sleeping on shoulder")
            ]
        case .hips:
            return [
                PainFactor(id: "walking", name: "Walking long distances"),
                PainFactor(id: "sitting", name: "Sitting cross-legged"),
                PainFactor(id: "climbing", name: "Climbing stairs"),
                PainFactor(id: "running", name: "Running"),
                PainFactor(id: "lying", name: "Lying on side")
            ]
        case .wrists:
            return [
                PainFactor(id: "typing", name: "Typing/computer work"),
                PainFactor(id: "gripping", name: "Gripping objects"),
                PainFactor(id: "twisting", name: "Wrist twisting"),
                PainFactor(id: "lifting", name: "Lifting objects"),
                PainFactor(id: "writing", name: "Writing/drawing")
            ]
        }
    }
}

struct PainSubArea: Identifiable, Codable, Hashable {
    let id: String
    let name: String
}

struct PainFactor: Identifiable, Codable, Hashable {
    let id: String
    let name: String
}