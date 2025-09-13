import SwiftUI

struct DiagBootView: View {
    let onContinue: () -> Void
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "wrench.and.screwdriver")
                    .font(.system(size: 42, weight: .semibold))
                Text("Boot OK (Safe Mode)")
                    .font(.title2).bold()
                Text("The app was launched in diagnostic mode.\nYou can clear caches and proceed.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
                HStack(spacing: 12) {
                    Button("Clear Caches") {
                        URLCache.shared.removeAllCachedResponses()
                        if let id = Bundle.main.bundleIdentifier {
                            UserDefaults.standard.removePersistentDomain(forName: id)
                        }
                    }
                    .buttonStyle(.bordered)
                    Button("Continue to App") { onContinue() }
                        .buttonStyle(.borderedProminent)
                }
                .padding(.top, 4)
                Spacer()
            }
            .padding()
            .navigationTitle("Diagnostics")
        }
    }
}