//
//  PainReasoner.swift
//  EverForm
//
//  Rule-based pain classification and plan generation engine
//

import SwiftUI

class PainReasoner {
    
    // MARK: - Main Reasoning Method
    static func generateResult(from assessment: PainAssessment) -> PainAssessmentResult {
        let classification = classifyPain(assessment)
        let riskLevel = determineRiskLevel(assessment)
        let planBlocks = generatePlanBlocks(for: assessment, classification: classification, riskLevel: riskLevel)
        
        return PainAssessmentResult(
            assessment: assessment,
            classification: classification,
            riskLevel: riskLevel,
            suggestedBlocks: planBlocks,
            timestamp: Date()
        )
    }
    
    // MARK: - Classification Logic
    private static func classifyPain(_ assessment: PainAssessment) -> String {
        let area = assessment.area
        let qualities = assessment.qualities
        let symptoms = assessment.symptoms
        let duration = assessment.duration
        let severity = assessment.severity
        
        // Check for red flags first
        if !assessment.redFlags.isEmpty {
            return "Potential red flags detected. Seek medical care."
        }
        
        // Nerve-related symptoms
        if symptoms.contains(.tinglingNumbness) || symptoms.contains(.radiation) || symptoms.contains(.weakness) {
            return "Possible nerve irritation"
        }
        
        // Area-specific classifications
        switch area {
        case .neck, .back:
            if qualities.contains(.stiffness) && duration != .moreThanSixMonths && !symptoms.contains(.radiation) {
                return "Likely muscle strain/tension"
            }
            if qualities.contains(.burning) || qualities.contains(.tingling) {
                return "Possible nerve involvement"
            }
            
        case .shoulders, .knees, .wrists:
            if (duration == .oneToSixWeeks || duration == .oneToThreeMonths) && qualities.contains(.dullAching) {
                return "Likely overuse/tendinopathy"
            }
            if severity >= 7 && duration == .today {
                return "Possible acute injury"
            }
            
        case .hips:
            if qualities.contains(.stiffness) && !qualities.contains(.sharp) {
                return "Likely muscle tightness"
            }
            if symptoms.contains(.radiation) {
                return "Possible referred pain"
            }
        }
        
        // Duration-based classifications
        switch duration {
        case .today, .lessThanWeek:
            return "Likely acute strain"
        case .oneToSixWeeks, .oneToThreeMonths:
            return "Likely subacute condition"
        default:
            return "Likely chronic condition"
        }
    }
    
    // MARK: - Risk Level Determination
    private static func determineRiskLevel(_ assessment: PainAssessment) -> RiskLevel {
        if !assessment.redFlags.isEmpty {
            return .high
        }
        
        if assessment.severity >= 8 || assessment.symptoms.contains(.weakness) {
            return .moderate
        }
        
        if assessment.functionalImpact == .adlAffected || assessment.duration == .moreThanSixMonths {
            return .moderate
        }
        
        return .low
    }
    
    // MARK: - Plan Block Generation
    private static func generatePlanBlocks(for assessment: PainAssessment, classification: String, riskLevel: RiskLevel) -> [PlanBlock] {
        var blocks: [PlanBlock] = []
        
        // Today's plan (always included)
        blocks.append(generateTodayBlock(for: assessment))
        
        // 48-72 hour plan
        blocks.append(generateFortyEightHourBlock(for: assessment))
        
        // Week 1 plan (if not high risk)
        if riskLevel != .high {
            blocks.append(generateWeekOneBlock(for: assessment, classification: classification))
        }
        
        // Ongoing plan for chronic conditions
        if assessment.duration == .moreThanSixMonths {
            blocks.append(generateOngoingBlock(for: assessment))
        }
        
        return blocks
    }
    
    // MARK: - Today Block
    private static func generateTodayBlock(for assessment: PainAssessment) -> PlanBlock {
        var activities = [
            PlanActivity(
                title: "Box Breathing",
                description: "4-4-4-4 breathing pattern to down-regulate nervous system",
                type: .breathing,
                duration: "5 minutes"
            ),
            PlanActivity(
                title: "Gentle Mobility",
                description: getGentleMobilityActivity(for: assessment.area),
                type: .mobility,
                duration: "10 minutes"
            )
        ]
        
        // Add isometric if appropriate
        if assessment.severity <= 6 && assessment.functionalImpact != .adlAffected {
            activities.append(
                PlanActivity(
                    title: "Isometric Hold",
                    description: getIsometricActivity(for: assessment.area),
                    type: .stability,
                    duration: "3-5 holds"
                )
            )
        }
        
        return PlanBlock(
            title: "Today (10-15 min)",
            description: "Immediate relief and calming",
            timeFrame: .today,
            activities: activities
        )
    }
    
    // MARK: - 48-72 Hour Block
    private static func generateFortyEightHourBlock(for assessment: PainAssessment) -> PlanBlock {
        var activities = [
            PlanActivity(
                title: "Gentle Range of Motion",
                description: "Move through comfortable range, avoid painful end-range",
                type: .mobility,
                duration: "10 minutes, 2-3x daily"
            ),
            PlanActivity(
                title: "Pain-Free Movement",
                description: "Continue with activities that don't increase pain",
                type: .mobility,
                duration: "As tolerated"
            )
        ]
        
        // Add temperature therapy based on duration
        if assessment.duration == .today || assessment.duration == .lessThanWeek {
            activities.append(
                PlanActivity(
                    title: "Ice Therapy",
                    description: "15 minutes on, 15 minutes off if inflammation present",
                    type: .ice,
                    duration: "As needed"
                )
            )
        } else {
            activities.append(
                PlanActivity(
                    title: "Heat Therapy",
                    description: "Apply heat for 15-20 minutes to increase blood flow",
                    type: .heat,
                    duration: "As needed"
                )
            )
        }
        
        return PlanBlock(
            title: "48-72 Hours",
            description: "Early recovery and movement",
            timeFrame: .fortyEightHours,
            activities: activities
        )
    }
    
    // MARK: - Week 1 Block
    private static func generateWeekOneBlock(for assessment: PainAssessment, classification: String) -> PlanBlock {
        var activities = [
            PlanActivity(
                title: "Progressive Mobility",
                description: getProgressiveMobilityActivity(for: assessment.area),
                type: .mobility,
                duration: "15 minutes daily"
            ),
            PlanActivity(
                title: "Stability Exercises",
                description: getStabilityActivity(for: assessment.area),
                type: .stability,
                duration: "10 minutes daily"
            ),
            PlanActivity(
                title: "Posture/Ergonomics",
                description: getPostureAdvice(for: assessment.area),
                type: .posture,
                duration: "Throughout day"
            )
        ]
        
        // Add nerve glides if nerve-related
        if classification.contains("nerve") {
            activities.append(
                PlanActivity(
                    title: "Nerve Gliding",
                    description: "Gentle nerve mobility exercises",
                    type: .mobility,
                    duration: "5 minutes daily"
                )
            )
        }
        
        return PlanBlock(
            title: "Week 1",
            description: "Building foundation for recovery",
            timeFrame: .weekOne,
            activities: activities
        )
    }
    
    // MARK: - Ongoing Block
    private static func generateOngoingBlock(for assessment: PainAssessment) -> PlanBlock {
        return PlanBlock(
            title: "Ongoing Management",
            description: "Long-term strategies for chronic pain",
            timeFrame: .ongoing,
            activities: [
                PlanActivity(
                    title: "Regular Movement Routine",
                    description: "Consistent mobility and strengthening program",
                    type: .mobility,
                    duration: "20-30 minutes, 3-4x weekly"
                ),
                PlanActivity(
                    title: "Stress Management",
                    description: "Include breathing and relaxation techniques",
                    type: .breathing,
                    duration: "10 minutes daily"
                ),
                PlanActivity(
                    title: "Activity Modification",
                    description: "Identify and modify aggravating activities",
                    type: .posture,
                    duration: "Ongoing"
                )
            ]
        )
    }
    
    // MARK: - Area-Specific Activity Helpers
    private static func getGentleMobilityActivity(for area: PainArea) -> String {
        switch area {
        case .neck: return "Gentle neck circles and chin tucks"
        case .back: return "Cat-cow stretches and gentle pelvic tilts"
        case .shoulders: return "Shoulder rolls and pendulum swings"
        case .knees: return "Gentle knee extensions and heel slides"
        case .hips: return "Gentle hip circles and leg swings"
        case .wrists: return "Wrist circles and finger stretches"
        }
    }
    
    private static func getIsometricActivity(for area: PainArea) -> String {
        switch area {
        case .neck: return "Gentle isometric neck holds in neutral position"
        case .back: return "Gentle core bracing exercises"
        case .shoulders: return "Wall push-ups or isometric shoulder holds"
        case .knees: return "Quad sets or hamstring sets"
        case .hips: return "Glute sets or hip abduction holds"
        case .wrists: return "Wrist extension/flexion isometric holds"
        }
    }
    
    private static func getProgressiveMobilityActivity(for area: PainArea) -> String {
        switch area {
        case .neck: return "Progressive neck ROM exercises"
        case .back: return "Thoracic spine mobility drills"
        case .shoulders: return "Shoulder CARs (Controlled Articular Rotations)"
        case .knees: return "Controlled knee flexion/extension"
        case .hips: return "Hip CARs and progressive stretches"
        case .wrists: return "Wrist CARs and progressive stretches"
        }
    }
    
    private static func getStabilityActivity(for area: PainArea) -> String {
        switch area {
        case .neck: return "Deep neck flexor strengthening"
        case .back: return "Bird-dog exercises and dead bugs"
        case .shoulders: return "Scapular stabilization exercises"
        case .knees: return "Mini-squats and step-ups"
        case .hips: return "Glute bridges and clamshells"
        case .wrists: return "Wrist stabilization exercises"
        }
    }
    
    private static func getPostureAdvice(for area: PainArea) -> String {
        switch area {
        case .neck: return "Monitor at eye level, avoid forward head posture"
        case .back: return "Maintain neutral spine, use lumbar support"
        case .shoulders: return "Keep shoulders back and down, avoid slouching"
        case .knees: return "Avoid deep squats, maintain alignment"
        case .hips: return "Avoid prolonged sitting, use proper lifting technique"
        case .wrists: return "Keep wrists neutral, avoid prolonged flexion"
        }
    }
}