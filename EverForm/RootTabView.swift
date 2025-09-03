import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            OverviewView()
                .tabItem { Label("Overview", systemImage: "house.fill") }

            CoachView()
                .tabItem { Label("Coach", systemImage: "brain.head.profile") }

            ScanView()
                .tabItem { Label("Scan", systemImage: "camera.viewfinder") }

            ProgressViewEF()
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
        }
    }
}
