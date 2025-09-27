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
        didSet { 
            stored = scheme.rawValue
            if hasInitialized {
                applyGlobalBars()
            }
        }
    }
    
    private var hasInitialized = false
    
    init() {
        self.scheme = ThemeMode(rawValue: stored) ?? .system
        // Don't call applyGlobalBars() during init to avoid circular dependency
    }
    
    func initialize() {
        guard !hasInitialized else { return }
        hasInitialized = true
        applyGlobalBars()
    }
}

// MARK: - UIKit Bars
extension ThemeManager {
    func applyGlobalBars() {
        // Use direct color values to avoid circular dependency during initialization
        let bg: UIColor
        let hair: UIColor?
        
        if hasInitialized {
            // After initialization, use the DSColor system
            bg = UIColor(DSColor.barBackground)
            // Remove separator for all themes - no hairline stripes
            hair = nil
        } else {
            // During initialization, use direct color values to avoid circular dependency
            switch scheme {
            case .dark:
                bg = UIColor(hex: "#111214")  // New dark theme background
                hair = nil // No separator for any theme
            case .light:
                bg = UIColor.white
                hair = nil // No separator for any theme
            case .system:
                bg = UIColor(hex: "#EAD6BF")
                hair = nil // No separator for any theme
            }
        }

        // UINavigationBar
        let nav = UINavigationBarAppearance()
        nav.configureWithOpaqueBackground()
        nav.backgroundColor = bg
        nav.shadowColor = hair
        
        // Set title colors for dark mode
        if scheme == .dark {
            nav.titleTextAttributes = [.foregroundColor: UIColor.white]
            nav.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }

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

// MARK: - Hex helpers
extension Color {
    init(hex: String, alpha: Double = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
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

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: (r, g, b) = ((int >> 8)*17, (int >> 4 & 0xF)*17, (int & 0xF)*17)
        case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (r, g, b) = (0, 0, 0)
        }
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: alpha)
    }
}