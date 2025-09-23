import SwiftUI

struct ContentView: View {
    @StateObject private var router = NavigationRouter()

    var body: some View {
        let _ = print("[ContentView] router instance: \(ObjectIdentifier(router))")
        NavigationStack(path: $router.path) {
            RootTabView()
                .environmentObject(router)
        }
        .navigationDestination(for: EFRoute.self) { route in
            switch route {
            case .breathwork:
                BreathworkView()
                    .navigationTitle("Breathwork")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(DSColor.bg, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
            case .fixPain:
                FixPainView()
                    .navigationTitle("Fix Pain")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(DSColor.bg, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
            case .lookMaxing:
                LookMaxingView()
                    .navigationTitle("Look Maxing")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbarBackground(DSColor.bg, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
            default:
                EmptyView()
            }
        }
    }
}
