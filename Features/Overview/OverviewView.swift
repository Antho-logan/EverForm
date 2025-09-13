import SwiftUI
import UIKit

struct OverviewView: View {
    @State private var route: LocalRoute?
    @State private var showProfileMenu = false
    @Environment(HydrationService.self) private var hydrationService
    @EnvironmentObject private var journalStore: JournalStore
    @EnvironmentObject private var appearance: AppearanceStore
    @Environment(\.colorScheme) private var colorScheme
    @State private var showWaterOptions = false
    @State private var showWeightSheet = false
    @State private var showCustomWaterSheet = false
    @State private var toastText: String? = nil
    @State private var customMl: String = ""
    @AppStorage("profile.weight") private var lastWeight: String = ""
    
    private var isDark: Bool { colorScheme == .dark }

    // MARK: - Calories (today)
    private var ov_todayCalories: Int {
        return journalStore.todaysTotalCalories
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // ------- Stats Grid (existing cards) -------
                    // KPI grid (4 tiles)
                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        KPICard(icon: "figure.walk", title: "8.4K", subtitle: "STEPS")
                        KPICard(icon: "drop.fill", title: "\(ov_todayCalories) / 2661", subtitle: "CALORIES")
                        KPICard(icon: "bed.double.fill", title: "7h 30m", subtitle: "SLEEP")
                        KPICard(icon: "drop", title: "\(hydrationService.todayMl) ml", subtitle: "HYDRATION")
                    }
                    .padding(.horizontal, 20)

                    Text("Today's Plan")
                        .font(.title2.weight(.semibold))
                        .padding(.top, 12)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color("TextPrimary"))

                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            planCard(title: "Training", subtitle: "Upper Body", system: "dumbbell.fill", color: .green) {
                                EFRouter.open(.training)
                            }
                            planCard(title: "Nutrition", subtitle: "2661 kcal target", system: "fork.knife", color: .orange) {
                                EFRouter.open(.nutrition)
                            }
                        }
                        HStack(spacing: 16) {
                            planCard(title: "Recovery", subtitle: "Bedtime 22:30", system: "moon.fill", color: .blue) {
                                EFRouter.open(.recovery)
                            }
                            planCard(title: "Mobility", subtitle: "Hips & Shoulders", system: "figure.walk.motion", color: .purple) {
                                EFRouter.open(.mobility)
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // ------- Quick Actions -------
                    Text("Quick Actions")
                        .font(.title2.weight(.semibold))
                        .padding(.top, 12)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color("TextPrimary"))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            quickActionButton(icon: "drop.fill", title: "Add Water", color: .blue) {
                                hydrationService.addWater(ml: 250)
                                toastText = "+250 ml"
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { toastText = nil }
                            }
                            .onLongPressGesture { showWaterOptions = true }

                            quickActionButton(icon: "wind", title: "Breathwork", color: .green) {
                                route = .breathwork
                            }

                            quickActionButton(icon: "cross.case.fill", title: "Fix Pain", color: .red) {
                                route = .fixPain
                            }

                            quickActionButton(icon: "person.fill.viewfinder", title: "Look Maxing", color: .purple) {
                                route = .lookMaxing
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 24)
                }
                .padding(.top, 8)
            }
            .scrollContentBackground(.hidden)
            .background(isDark ? AnyView(Color.clear.ignoresSafeArea()) : AnyView(DSColor.appBackground.ignoresSafeArea()))
            .efDarkCanvas()
            .toolbarBackground(DSColor.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle("Overview")
            .navigationBarTitleDisplayMode(.large)
            .onAppear { NavBlendLocal.apply() }
            .onDisappear { EFNavBarStyler.resetToDefault() }
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
                if let toastText = toastText {
                    Text(toastText)
                        .font(.subheadline).bold()
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(isDark ? AnyShapeStyle(Color.black.opacity(0.3)) : AnyShapeStyle(.ultraThinMaterial), in: Capsule())
                        .padding(.bottom, 8)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .confirmationDialog("Add water", isPresented: $showWaterOptions, titleVisibility: .visible) {
                Button("+250 ml") {
                    hydrationService.addWater(ml: 250)
                    toastText = "+250 ml"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { toastText = nil }
                }
                Button("+330 ml") {
                    hydrationService.addWater(ml: 330)
                    toastText = "+330 ml"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { toastText = nil }
                }
                Button("+500 ml") {
                    hydrationService.addWater(ml: 500)
                    toastText = "+500 ml"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { toastText = nil }
                }
                Button("Custom…") {
                    showCustomWaterSheet = true
                }
                Button("Cancel", role: .cancel) {}
            }
            .sheet(isPresented: $showCustomWaterSheet) {
                VStack(spacing: 20) {
                    Text("Add Water").font(.title2).bold()
                    TextField("Amount (ml)", text: $customMl)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    Button("Add") {
                        if let ml = Int(customMl.trimmingCharacters(in: .whitespaces)), ml > 0 {
                            hydrationService.addWater(ml: ml)
                            toastText = "+\(ml) ml"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { toastText = nil }
                        }
                        customMl = ""
                        showCustomWaterSheet = false
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Cancel", role: .cancel) { showCustomWaterSheet = false }
                    Spacer()
                }
                .padding()
                .presentationDetents([.height(260), .medium])
            }
            .sheet(isPresented: $showWeightSheet) {
                VStack(spacing: 20) {
                    Text("Log Weight").font(.title2).bold()
                    TextField("e.g. 74.2", text: $lastWeight)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    Button("Save") {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        toastText = "Saved \(lastWeight) \(unitLabel())"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { toastText = nil }
                        showWeightSheet = false
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Cancel", role: .cancel) { showWeightSheet = false }
                    Spacer()
                }
                .padding()
                .presentationDetents([.height(260), .medium])
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
        case .lookMaxing:      NavigationStack { LookMaxingView() }

        case .profile:         NavigationStack { ProfileView() }
        case .display:         NavigationStack { DisplaySettingsView() }
        case .security:        NavigationStack { SecuritySettingsView() }
        case .export:          NavigationStack { ExportDataView() }
        case .help:            NavigationStack { HelpView() }
        case .report:          NavigationStack { ReportBugView() }
        }
    }

    private func unitLabel() -> String {
        // Optional: infer from Profile units; fallback to kg
        return UserDefaults.standard.string(forKey: "ef.units") == "Imperial" ? "lb" : "kg"
    }

    // MARK: UI helpers

    private func planCard(title: String, subtitle: String, system: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
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
        .buttonStyle(.plain)
    }

    private func quickActionButton(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(color)

                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(minWidth: 72, minHeight: 72)
            .padding(12)
            .background(DSColor.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: DSColor.black.opacity(0.06), radius: 8, y: 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
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