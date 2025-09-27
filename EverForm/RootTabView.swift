import SwiftUI
import UIKit

struct RootTabView: View {
    @EnvironmentObject private var journalStore: JournalStore
    @EnvironmentObject private var appearance: AppearanceStore
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedTab: Int = 0
    @State private var activeRoute: EFRoute?

    init() {
        // Configure Tab Bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(DSColor.bg)
        tabBarAppearance.shadowColor = .clear
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            OverviewView()
                .environmentObject(router)
                .tabItem { Label("Overview", systemImage: "house.fill") }
                .tag(0)

            CoachView()
                .tabItem { Label("Coach", systemImage: "brain.head.profile") }
                .tag(1)

            ScanView()
                .tabItem { Label("Scan", systemImage: "camera.viewfinder") }
                .tag(2)

            ProgressViewEF()
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
                .tag(3)
        }
        .tint(DSColor.brand)
        .scrollContentBackground(.hidden)
        .background(DSColor.bg.ignoresSafeArea())
        .toolbarBackground(DSColor.bg, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(DSColor.bg, for: .navigationBar)
        .toolbarColorScheme(colorScheme, for: .navigationBar)
        .onReceive(NotificationCenter.default.publisher(for: .efRoute)) { note in
            guard let route = note.object as? EFRoute else { return }
            switch route {
            case .coachTab:
                selectedTab = 1 // Switch to Coach tab
            default:
                activeRoute = route
            }
        }
        .sheet(item: $activeRoute) { route in
            switch route {
            case .training: TrainingViewEF()
            case .nutrition: NutritionViewEF().environmentObject(journalStore).presentationBackground(DSColor.bg)
            case .recovery: RecoveryViewEF().presentationBackground(DSColor.bg)
            case .mobility: MobilityViewEF().presentationBackground(DSColor.bg)
            default: EmptyView()
            }
        }
    }
}
