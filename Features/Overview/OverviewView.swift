import SwiftUI
import UIKit

private let statColumns = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16)
]

struct OverviewView: View {
    @EnvironmentObject private var router: NavigationRouter
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

    // MARK: - Layout
    let twoCols = [GridItem(.flexible(), spacing: EFSpacing.grid, alignment: .top),
                   GridItem(.flexible(), spacing: EFSpacing.grid, alignment: .top)]
    let actionsCols = [GridItem(.adaptive(minimum: 90), spacing: EFSpacing.grid, alignment: .top)]

    // MARK: - Calories (today)
    private var ov_todayCalories: Int {
        return journalStore.todaysTotalCalories
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: EFSpacing.section) {
                    // Stats Grid - 2x2 grid with large cards
                    LazyVGrid(columns: statColumns, alignment: .center, spacing: 16) {
                        EFStatCardView(
                            icon: "figure.walk",
                            iconTint: DSColor.accentSuccess,
                            title: "Steps",
                            value: "8.4K",
                            subtitle: "",
                            style: StatCardStyle.forKind(.steps)
                        )
                        EFStatCardView(
                            icon: "drop.fill",
                            iconTint: DSColor.accentNutrition,
                            title: "Calories",
                            value: "\(ov_todayCalories) / 2661",
                            subtitle: "",
                            style: StatCardStyle.forKind(.calories)
                        )
                        EFStatCardView(
                            icon: "bed.double.fill",
                            iconTint: DSColor.accentRecovery,
                            title: "Sleep",
                            value: "7h 30m",
                            subtitle: "",
                            style: StatCardStyle.forKind(.sleep)
                        )
                        EFStatCardView(
                            icon: "drop.circle.fill",
                            iconTint: DSColor.accentMobility,
                            title: "Hydration",
                            value: "\(hydrationService.todayMl) ml",
                            subtitle: "",
                            style: StatCardStyle.forKind(.hydration)
                        )
                    }
                    .padding(.horizontal, 20)

                    // Today's Plan
                    EFSectionHeader("Today's Plan")
                        .padding(.horizontal, EFSpacing.page)

                    LazyVGrid(columns: twoCols, spacing: EFSpacing.grid) {
                        planCard(title: "Training", subtitle: "Upper Body", system: "dumbbell.fill", color: DSColor.accentSuccess) {
                            EFRouter.open(.training)
                        }
                        planCard(title: "Nutrition", subtitle: "2661 kcal target", system: "fork.knife", color: DSColor.accentNutrition) {
                            EFRouter.open(.nutrition)
                        }
                        planCard(title: "Recovery", subtitle: "Bedtime 22:30", system: "moon.fill", color: DSColor.accentRecovery) {
                            EFRouter.open(.recovery)
                        }
                        planCard(title: "Mobility", subtitle: "Hips & Shoulders", system: "figure.walk.motion", color: DSColor.accentMobility) {
                            EFRouter.open(.mobility)
                        }
                    }
                    .padding(.horizontal, EFSpacing.page)

                    // Quick Actions
                    QuickActionsRow(
                        onAddWater: {
                            hydrationService.addWater(ml: 250)
                            toastText = "+250 ml"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { toastText = nil }
                        }
                    )
                }
                .padding(.top, 8)
                .padding(.bottom, EFSafe.bottom)
            }
            .scrollContentBackground(.hidden)
            .background(DSColor.bg.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                OverviewHeader(
                    title: "Overview",
                    showMenu: $showProfileMenu,
                    onTapProfile: { showProfileMenu = true },
                    onProfile: { router.go(.profile) },
                    onDisplay: { router.go(.display) },
                    onSecurity: { router.go(.security) },
                    onExport: { router.go(.export) },
                    onHelp: { router.go(.help) },
                    onReport: { router.go(.report) }
                )
            }
            .onAppear { NavBlendLocal.apply() }
            .onDisappear { EFNavBarStyler.resetToDefault() }
            .overlay(alignment: .bottom) {
                if let toastText = toastText {
                    Text(toastText)
                        .font(.subheadline).bold()
                        .padding(.horizontal, 14).padding(.vertical, 10)
                        .background(isDark ? AnyShapeStyle(DSColor.cardElevated.opacity(0.3)) : AnyShapeStyle(.ultraThinMaterial), in: Capsule())
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

    
    private func unitLabel() -> String {
        // Optional: infer from Profile units; fallback to kg
        return UserDefaults.standard.string(forKey: "ef.units") == "Imperial" ? "lb" : "kg"
    }

    // MARK: UI helpers

    private func planCard(title: String, subtitle: String, system: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            EFCard {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        PlanIcon(systemName: system, tint: color)
                        Text(title)
                        .font(.headline)
                        .foregroundStyle(DSColor.textPrimary)
                    }
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(DSColor.textSecondary)
                    HStack {
                        Spacer()
                        Text(title == "Training" ? "Start" : (title == "Nutrition" ? "Start" : (title == "Recovery" ? "Open" : "Start")))
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(color)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(color.opacity(0.12), in: Capsule())
                    }
                }
                .padding(14)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Overview-specific styling
private extension View {
    func overviewSectionTitleStyle() -> some View {
        modifier(OverviewSectionTitleStyle())
    }
}

// MARK: - Overview Section Title Styling
private struct OverviewSectionTitleStyle: ViewModifier {

    func body(content: Content) -> some View {
        content
            .foregroundStyle(DSColor.textPrimary)
            .background(Color.clear)
    }
}
