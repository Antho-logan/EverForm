import SwiftUI

struct AppearanceSettingsView: View {
    @EnvironmentObject private var theme: EFThemeManager
    @AppStorage("ef.appearance") private var themeMode: String = EFAppearance.system.rawValue

    var body: some View {
        NavigationStack {
            Form {
                Section("Theme") {
                    Picker("Appearance", selection: Binding(
                        get: { themeMode },
                        set: { newValue in
                            themeMode = newValue
                            // Apply theme change immediately
                            switch newValue {
                            case "system": theme.apply(style: .system)
                            case "light": theme.apply(style: .light)
                            case "dark": theme.apply(style: .dark)
                            default: theme.apply(style: .system)
                            }
                        }
                    )) {
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
        .environmentObject(EFThemeManager())
}
