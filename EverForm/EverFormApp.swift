//
//  EverFormApp.swift
//  EverForm
//
//  Created by Anthony Logan on 13/08/2025.
//

import SwiftUI
import Observation

@main
struct EverFormApp: App {
    @StateObject private var theme = EFTheme.shared
    @State private var appearance = AppearanceStore()
    @State private var themeManager = ThemeManager()
    @State private var efThemeManager = EFThemeManager()
    @State private var forceDiag = ProcessInfo.processInfo.environment["EF_FORCE_DIAG"] == "1"

    // Own long-lived state here (create only for types that exist in the repo)
    @State private var appRouter          = AppRouter()
    @State private var workoutStore       = WorkoutStore()
    @State private var nutritionStore     = NutritionStore()
    @State private var hydrationService   = HydrationService()
    @State private var profileStore       = ProfileStore()
    @State private var notesStore         = ProfileNotesStore()
    @State private var attachmentStore    = AttachmentStore()
    @State private var journalStore       = JournalStore()


    var body: some Scene {
        WindowGroup {
            RootSwitcher()
                .environment(appearance)
                // Inject Observation (@Observable) stores
                .environment(appRouter)
                .environment(workoutStore)
                .environment(nutritionStore)
                .environment(hydrationService)
                .environment(profileStore)
                .environment(notesStore)
                .environment(attachmentStore)
                .environmentObject(themeManager)
                .environmentObject(efThemeManager)

                // ALSO inject as EnvironmentObject for any store that conforms to ObservableObject.
                // CoachCoordinator uses singleton pattern, so we don't inject it here
                .environmentObject(CoachCoordinator.shared)
                .environmentObject(theme)
                .environmentObject(journalStore)
                .preferredColorScheme(nil) // Let system handle based on theme manager

                .onAppear {
                    print("EverForm launched; stores injected")
                    // Initialize theme manager after app is fully loaded to avoid circular dependency
                    ThemeManager.shared.initialize()
                    if !forceDiag {
                        checkOnboardingStatus()
                    }
                }
        }
    }

    @ViewBuilder
    private func RootSwitcher() -> some View {
        if forceDiag {
            DiagBootView { forceDiag = false }
                .environment(appearance)
                .environment(appRouter)
                .environment(workoutStore)
                .environment(nutritionStore)
                .environment(hydrationService)
                .environment(profileStore)
                .environment(notesStore)
                .environment(attachmentStore)
                .environmentObject(themeManager)
                .environmentObject(efThemeManager)
                .environmentObject(CoachCoordinator.shared)
                .environmentObject(theme)
                .environmentObject(journalStore)
                .preferredColorScheme(nil) // Let system handle based on theme manager
        } else {
            ContentView()
        }
    }
    
    private func checkOnboardingStatus() {
        // If user hasn't completed onboarding, show express onboarding
        if !profileStore.hasCompletedOnboarding {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                appRouter.fullScreen = .expressOnboarding
            }
        }
    }
}
