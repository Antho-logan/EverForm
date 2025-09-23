//
//  QuickActionsManager.swift
//  EverForm
//
//  Manager for quick actions ordering and persistence
//

import SwiftUI
import Observation

@Observable
final class QuickActionsManager {
    private let userDefaults = UserDefaults.standard
    private let orderKey = "quickActions.order"
    
    var quickActions: [QuickAction] = []
    var isReordering = false
    
    init() {
        loadQuickActions()
    }
    
    private func loadQuickActions() {
        // Load saved order from UserDefaults
        guard let orderData = userDefaults.data(forKey: orderKey) else {
            // First time - use default order
            quickActions = QuickAction.defaultActions
            saveOrder()
            return
        }

        do {
            let savedIDs = try JSONDecoder().decode([UUID].self, from: orderData)
            let defaultActionsDict = Dictionary(uniqueKeysWithValues: QuickAction.defaultActions.map { ($0.id, $0) })

            // Restore saved order
            var orderedActions: [QuickAction] = []

            // Add actions in saved order
            for actionId in savedIDs {
                if let action = defaultActionsDict[actionId] {
                    orderedActions.append(action)
                }
            }

            // Add any new actions that weren't in the saved order
            for defaultAction in QuickAction.defaultActions {
                if !orderedActions.contains(where: { $0.id == defaultAction.id }) {
                    orderedActions.append(defaultAction)
                }
            }

            quickActions = orderedActions
        } catch {
            // If decoding fails, use default order
            quickActions = QuickAction.defaultActions
        }
    }
    
    private func saveOrder() {
        let order = quickActions.map { $0.id }
        do {
            let data = try JSONEncoder().encode(order)
            userDefaults.set(data, forKey: orderKey)
        } catch {
            print("Failed to save quick actions order: \(error)")
        }
    }
    
    func startReordering() {
        isReordering = true
    }
    
    func stopReordering() {
        isReordering = false
        saveOrder()
    }
    
    func moveAction(from source: IndexSet, to destination: Int) {
        quickActions.move(fromOffsets: source, toOffset: destination)
        saveOrder()
    }
    
    func executeAction(_ action: QuickAction, 
                      viewModel: DashboardViewModel,
                      openExplain: @escaping (String, String) -> Void,
                      showBreathworkSheet: @escaping () -> Void,
                      showPainHelperSheet: @escaping () -> Void) {
        
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        switch action.actionType {
        case .addWater:
            DebugLog.info("Overview: Add Water quick action tapped")
            viewModel.addWater(250)
            
        case .breathwork:
            DebugLog.info("Overview: Breathwork quick action tapped")
            showBreathworkSheet()
            
        case .fixPain:
            DebugLog.info("Overview: Fix pain quick action tapped")
            showPainHelperSheet()
            
        case .lookMaxing:
            DebugLog.info("Overview: Look Maxing quick action tapped")
            viewModel.openLookMaxing()
        }
    }
}
