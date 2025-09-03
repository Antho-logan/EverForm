import SwiftUI

struct OverviewView: View {
    @State private var route: LocalRoute?
    @State private var showProfileMenu = false
    @Environment(HydrationService.self) private var hydrationService

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {

                    // ------- Stats Grid (existing cards) -------
                    // KPI grid (4 tiles)
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        KPICard(icon: "figure.walk", title: "8.4K", subtitle: "STEPS")
                        KPICard(icon: "drop.fill", title: "1850 / 2661", subtitle: "CALORIES")
                        KPICard(icon: "bed.double.fill", title: "7h 30m", subtitle: "SLEEP")
                        KPICard(icon: "drop", title: "\(hydrationService.todayMl) ml", subtitle: "HYDRATION")
                    }
                    .padding(.horizontal, 20)

                    Section {
                        VStack(spacing: 14) {
                            HStack(spacing: 16) {
                                planCard(title: "Training", subtitle: "Upper Body", system: "dumbbell.fill", color: DSColor.accentTraining, destination: TrainingDetailView())
                                planCard(title: "Nutrition", subtitle: "2661 kcal target", system: "fork.knife", color: DSColor.accentNutrition, destination: NutritionDetailView())
                            }
                            HStack(spacing: 16) {
                                planCard(title: "Recovery", subtitle: "Bedtime 22:30", system: "moon.fill", color: DSColor.accentRecovery, destination: RecoveryDetailView())
                                planCard(title: "Mobility", subtitle: "Hips & Shoulders", system: "figure.walk.motion", color: DSColor.accentMobility, destination: MobilityDetailView())
                            }
                        }
                    } header: {
                        Text("Today's Plan")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(DSColor.textPrimary)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)

                    // ------- Quick Actions -------
                    VStack(spacing: 12) {
                        Text("Quick Actions")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(DSColor.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                            QuickActionTile(icon: "drop.fill", title: "Add Water", style: .water) {
                                hydrationService.addWater(ml: 250)
                            }
                            QuickActionTile(icon: "wind", title: "Breathwork", style: .success) {
                                route = .breathwork
                            }
                            QuickActionTile(icon: "cross.case.fill", title: "Fix Pain", style: .danger) {
                                route = .fixPain
                            }
                            QuickActionTile(icon: "brain.head.profile", title: "Ask Coach", style: .info) {
                                route = .askCoach
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 24)
                }
                .padding(.top, 8)
            }
            .background(DSColor.appBackground.ignoresSafeArea())
            .navigationTitle("Overview")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(DSColor.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Profile", action: { route = .profile })
                        Button("Display", action: { route = .display })
                        Button("Security", action: { route = .security })
                        Button("Export Data", action: { route = .export })
                        Button("Help", action: { route = .help })
                        Button("Report a Bug", action: { route = .report })
                    } label: {
                        ZStack {
                            Circle().fill(DSColor.card)
                                .frame(width: 30, height: 30)
                            Image(systemName: "person.fill")
                                .foregroundStyle(DSColor.brand)
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                }
            }
            .sheet(item: $route) {
                sheet(for: $0)
            }
            .overlay(alignment: .bottom) {
                if hydrationService.showToast {
                    Text("+\(hydrationService.lastAdded) ml")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(Capsule().fill(Color.teal))
                        .padding(.bottom, 24)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }

    @ViewBuilder private func sheet(for r: LocalRoute) -> some View {
        switch r {
        case .training, .nutrition, .recovery, .mobility:
            // These now use NavigationLink instead of sheets
            EmptyView()
        case .addWater:        NavigationStack { AddWaterView() }
        case .breathwork:      NavigationStack { BreathworkView() }
        case .fixPain:         NavigationStack { FixPainView() }
        case .askCoach:        NavigationStack { CoachView() }
        case .profile:         NavigationStack { ProfileView() }
        case .display:         NavigationStack { DisplaySettingsView() }
        case .security:        NavigationStack { SecuritySettingsView() }
        case .export:          NavigationStack { ExportDataView() }
        case .help:            NavigationStack { HelpCenterView() }
        case .report:          NavigationStack { ReportBugView() }
        }
    }

    // MARK: UI helpers

    private func planCard<Destination: View>(title: String, subtitle: String, system: String, color: Color, destination: Destination) -> some View {
        NavigationLink {
            destination
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: system)
                        .foregroundStyle(color)
                    Text(title).font(.headline).foregroundStyle(DSColor.textPrimary)
                }
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(DSColor.textSecondary)
                HStack {
                    Spacer()
                    Text(title == "Training" ? "Start Workout" : (title == "Nutrition" ? "Log Meal" : (title == "Recovery" ? "Open" : "Start")))
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(color)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(color.opacity(0.12), in: Capsule())
                }
            }
            .padding(16)
            .background(DSColor.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: DSColor.black.opacity(0.06), radius: 10, y: 6)
        }
    }


}

private struct KPICard: View {
    let icon: String, title: String, subtitle: String
    var body: some View {
        EFCard {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(DSColor.brand)
                Text(title).font(.title3.weight(.semibold)).foregroundStyle(DSColor.textPrimary)
                Text(subtitle).font(.caption).foregroundStyle(DSColor.textSecondary)
            }
        }
    }
}