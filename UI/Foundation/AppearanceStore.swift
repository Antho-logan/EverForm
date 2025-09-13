import SwiftUI
import Observation

@Observable
final class AppearanceStore: ObservableObject {
    enum Mode: String, CaseIterable, Identifiable { case system, light, dark
        var id: String { rawValue }
        var title: String {
            switch self { case .system: "System"; case .light: "Light"; case .dark: "Dark" }
        }
    }

    @ObservationIgnored @AppStorage("themeMode") private var stored = Mode.system.rawValue
    var mode: Mode {
        get { Mode(rawValue: stored) ?? .system }
        set { stored = newValue.rawValue }
    }

    var preferredColorScheme: ColorScheme? {
        switch mode { case .system: nil; case .light: .light; case .dark: .dark }
    }
    
    // Convert to AppAppearance for use with AppTheme
    var appAppearance: AppAppearance {
        switch mode {
        case .system: return .system
        case .light: return .light
        case .dark: return .dark
        }
    }
}