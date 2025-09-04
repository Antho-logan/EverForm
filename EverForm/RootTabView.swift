import SwiftUI

struct RootTabView: View {
    @State private var selectedTab: Int = 0
    @State private var activeRoute: EFRoute?

    var body: some View {
        TabView(selection: $selectedTab) {
            OverviewView()
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
        .background(DSColor.appBackground.ignoresSafeArea())
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
            case .nutrition: NutritionViewEF()
            case .recovery: RecoveryViewEF()
            case .mobility: MobilityViewEF()
            default: EmptyView()
            }
        }
    }
}
