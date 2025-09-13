import SwiftUI

struct AppearanceSettingsView: View {
    @AppStorage("ef.appearance") private var themeMode: String = EFAppearance.system.rawValue

    var body: some View {
        NavigationStack {
            Form {
                Section("Theme") {
                    Picker("Appearance", selection: $themeMode) {
                        ForEach(EFAppearance.allCases, id: \.rawValue) { mode in
                            Text(mode.rawValue.capitalized).tag(mode.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Display")
        }
    }
}

#Preview {
    AppearanceSettingsView()
}
