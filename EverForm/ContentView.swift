import SwiftUI

struct ContentView: View {
    @StateObject private var router = NavigationRouter()

    var body: some View {
        let _ = print("[ROOT] router:", ObjectIdentifier(router))
        NavigationStack(path: $router.path) {
            RootTabView()
                .environmentObject(router)
                .background(DSColor.bg.ignoresSafeArea())
                .navigationDestination(for: EFRoute.self) { route in
                    DestinationMapperView(route: route)
                        .environmentObject(router)
                }
        }
        .toolbarBackground(DSColor.bg, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onChange(of: router.path) { newPath in
            print("📍 PATH COUNT: \(newPath.count)")
            print("📍 CURRENT PATH: \(newPath)")
        }
        .onAppear {
            print("🚀 ContentView initialized with router: \(ObjectIdentifier(router))")
        }
        // Legacy sheet presentation (for backward compatibility)
        .sheet(item: $router.presentedRoute) { route in
            DestinationMapperView(route: route)
                .environmentObject(router)
                .background(DSColor.bg.ignoresSafeArea())
                .presentationDetents([.large])                // full-height card
                .presentationDragIndicator(.hidden)           // hide the grabber
                .interactiveDismissDisabled(false)            // allow swipe down
                .presentationCornerRadius(28)                 // rounded corners
        }
        .sheet(item: $router.modal) { modal in
            Group {
                switch modal {
                case .breathwork:
                    BreathworkView()
                        .environmentObject(router)
                case .fixPain:
                    FixPainSheetView()
                        .environmentObject(router)
                case .lookMaxing:
                    ModalScaffold(title: modal.title) {
                        LookMaxingView()
                            .environmentObject(router)
                    }
                }
            }
            // match Recovery/Nutrition behavior
            .presentationDetents([.large])
            .presentationCornerRadius(28)
            .interactiveDismissDisabled(false)
            .presentationDragIndicator(.hidden)
            .presentationBackground(Color(hex: "#EAD6BF"))
        }
    }
}
