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
        set { 
            stored = newValue.rawValue
            // Sync with ThemeManager for immediate UI updates
            DispatchQueue.main.async {
                switch newValue {
                case .system:
                    ThemeManager.shared.scheme = .system
                case .light:
                    ThemeManager.shared.scheme = .light
                case .dark:
                    ThemeManager.shared.scheme = .dark
                }
            }
        }
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
    
    // Initialize with ThemeManager sync
    init() {
        // Sync ThemeManager with stored value on launch
        switch mode {
        case .system:
            ThemeManager.shared.scheme = .system
        case .light:
            ThemeManager.shared.scheme = .light
        case .dark:
            ThemeManager.shared.scheme = .dark
        }
    }
}