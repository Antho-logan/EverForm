import SwiftUI
import Combine

enum ThemeMode: String, CaseIterable {
    case system   // EverForm beige theme
    case light    // iOS-style white
    case dark     // near-black
}

final class ThemeManager: ObservableObject, @unchecked Sendable {
    static let shared = ThemeManager()
    @AppStorage("display.appearance") private var stored: String = ThemeMode.system.rawValue
    @Published var scheme: ThemeMode = .system {
        didSet { stored = scheme.rawValue; applyGlobalBars() }
    }
    
    init() {
        self.scheme = ThemeMode(rawValue: stored) ?? .system
        applyGlobalBars()
    }
}

// MARK: - UIKit Bars
extension ThemeManager {
    func applyGlobalBars() {
        let bg = UIColor(DSColor.barBackground)
        let hair = UIColor(DSColor.borderHairline)

        // UINavigationBar
        let nav = UINavigationBarAppearance()
        nav.configureWithOpaqueBackground()
        nav.backgroundColor = bg
        nav.shadowColor = hair

        UINavigationBar.appearance().standardAppearance = nav
        UINavigationBar.appearance().scrollEdgeAppearance = nav
        UINavigationBar.appearance().compactAppearance = nav

        // UITabBar
        let tab = UITabBarAppearance()
        tab.configureWithOpaqueBackground()
        tab.backgroundColor = bg
        tab.shadowColor = hair

        UITabBar.appearance().standardAppearance = tab
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tab
        }
    }
}

// MARK: - Theme Manager Extensions
extension ThemeManager {
    var selectedTheme: ThemeMode { scheme }
    
    // Compatibility properties for EFDisplaySettingsView
    var selection: EFUserTheme {
        get {
            switch scheme {
            case .system: return .system
            case .light: return .light
            case .dark: return .dark
            }
        }
        set {
            switch newValue {
            case .system: scheme = .system
            case .light: scheme = .light
            case .dark: scheme = .dark
            }
        }
    }
    
    func set(_ theme: EFUserTheme) {
        switch theme {
        case .system: scheme = .system
        case .light: scheme = .light
        case .dark: scheme = .dark
        }
    }
}

extension ThemeMode {
    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

// MARK: - Hex helper
extension Color {
    init(hex: String, alpha: Double = 1.0) {
        var hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: (r, g, b) = ((int >> 8)*17, (int >> 4 & 0xF)*17, (int & 0xF)*17)
        case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (r, g, b) = (0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: alpha)
    }
}