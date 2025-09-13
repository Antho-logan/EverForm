import SwiftUI

// MARK: - Layout, Spacing and UI Constants
enum Layout {
    static let hPadding: CGFloat = 16
    static let vSpacing: CGFloat = 16
    static let gridSpacing: CGFloat = 12
    static let kpiTileHeight: CGFloat = 84
    static let planCardHeight: CGFloat = 144
    static let quickCardHeight: CGFloat = 92
    static let ringSize: CGFloat = 108
    
    // Section spacing
    static let headerToKPI: CGFloat = 12
    static let kpiToPlan: CGFloat = 16
    static let planToQuick: CGFloat = 16
    static let sectionTitleSpacing: CGFloat = 8
    static let ringToGrid: CGFloat = 16
}

enum Spacing { 
    static let xs: CGFloat = 8; 
    static let sm: CGFloat = 12
    static let md: CGFloat = 16; 
    static let lg: CGFloat = 20; 
    static let xl: CGFloat = 24 
}

enum Radius { 
    static let card: CGFloat = 18; 
    static let pill: CGFloat = 12 
}

enum Shadow { 
    static let card = Color.black.opacity(0.30) 
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red:   Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8)  & 0xFF) / 255.0,
            blue:  Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}

// Removed problematic UIColor extension that caused infinite recursion
// UIColor.init(Color) should use native iOS 15+ behavior

extension View {
    func efCardStyle(scheme: ColorScheme) -> some View {
        return self
            .background(scheme == .dark ? Color(hex: 0x141416) : Color.white.opacity(0.85))
            .overlay(RoundedRectangle(cornerRadius: Radius.card).stroke(scheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.08), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: Radius.card))
            .shadow(color: scheme == .dark ? Shadow.card : .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

public enum PlanAccent {
    public static let training  = Color.green   // #32D74B
    public static let nutrition = Color.orange  // #FF9F0A
    public static let recovery  = Color.blue    // #0A84FF
    public static let mobility  = Color.purple  // #BF5AF2
}

// MARK: - EF Theme Manager (for surgical theme patch)
import Combine

// MARK: - Global Theme (Light/Dark) and Colors used app-wide

public final class EFThemeOld: ObservableObject {
    // "system" | "light" | "dark"
    @AppStorage("ef.color.mode") public var storedMode: String = "system" {
        didSet { objectWillChange.send() }
    }
    public var colorSchemeOverride: ColorScheme? {
        switch storedMode {
        case "light": return .light
        case "dark":  return .dark
        default:      return nil
        }
    }
}

public enum EFColor {
    // Dark mode palette
    static let bgDark         = Color(red: 0.07, green: 0.08, blue: 0.10)   // #121419
    static let surfaceDark    = Color(red: 0.12, green: 0.12, blue: 0.14)   // #1F2024
    static let cardDark       = Color(red: 0.15, green: 0.15, blue: 0.17)
    static let textDark       = Color.white.opacity(0.92)
    static let subTextDark    = Color.white.opacity(0.65)
    static let dividerDark    = Color.white.opacity(0.08)

    // Light mode palette (beige family from your Scan screen)
    static let bgLight        = Color(red: 0.96, green: 0.94, blue: 0.89)   // warm beige
    static let surfaceLight   = Color.white.opacity(0.85)
    static let cardLight      = Color.white
    static let textLight      = Color.black.opacity(0.92)
    static let subTextLight   = Color.black.opacity(0.55)
    static let dividerLight   = Color.black.opacity(0.08)

    // Brand/action colors
    static let green  = Color(hue: 0.35, saturation: 0.70, brightness: 0.75)
    static let orange = Color(hue: 0.10, saturation: 0.80, brightness: 0.90)
    static let blue   = Color(hue: 0.60, saturation: 0.70, brightness: 0.85)
    static let purple = Color(hue: 0.78, saturation: 0.50, brightness: 0.85)
    static let teal   = Color(hue: 0.47, saturation: 0.55, brightness: 0.80)
    static let red    = Color(hue: 0.00, saturation: 0.75, brightness: 0.85)
    
    // Pain accent color (red for pain category)
    static let painAccent = Color(hue: 0.00, saturation: 0.75, brightness: 0.85)
    
    // Pill/Chip colors
    struct Pill {
        static let background = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.15, green: 0.15, blue: 0.17, alpha: 1.0)
            : UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        })
        
        static let selectedBackground = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.25, green: 0.15, blue: 0.15, alpha: 1.0)
            : UIColor(red: 1.0, green: 0.95, blue: 0.95, alpha: 1.0)
        })
        
        static let stroke = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.08)
            : UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.08)
        })
        
        static let selectedStroke = EFColor.painAccent
        
        static let text = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.92)
            : UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.92)
        })
        
        static let selectedText = EFColor.painAccent
        
        static let shadow = Color.black
    }
}

public struct EFBackground: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    public func body(content: Content) -> some View {
        content
            .background(
                Group {
                    if scheme == .dark { EFColor.bgDark }
                    else { EFColor.bgLight }
                }
                .ignoresSafeArea()
            )
    }
}
public extension View { func efBackground() -> some View { modifier(EFBackground()) } }

// Simple capsule pill
public struct EFPill: View {
    public let title: String
    public let color: Color
    public var body: some View {
        Text(title)
            .font(.callout.weight(.semibold))
            .padding(.horizontal, 16).padding(.vertical, 10)
            .background(color.opacity(0.18))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.45), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

// Card and Chip components moved to UI/Components/ to avoid duplicates

// MARK: - Design System Colors (Asset-based)
// Design tokens used across the app
public struct DSColor {
    // Legacy tokens (delegating to new system for compatibility)
    public static var appBackground: Color { appearanceAwareCanvas }
    public static var surface: Color       { appearanceAwareElevated }
    public static var card: Color          { appearanceAwareCard }
    public static var cardElevated: Color  { appearanceAwareElevated }
    public static var textPrimary: Color   { Color("TextPrimary") }
    public static var textSecondary: Color { Color("TextSecondary") }

    // New appearance-aware tokens
    public static var canvas: Color        { appearanceAwareCanvas }
    public static var elevated: Color      { appearanceAwareElevated }
    public static var stroke: Color        { appearanceAwareStroke }
    
    // Appearance-aware computed properties
    private static var appearanceAwareCanvas: Color {
      switch AppAppearanceLocal.current() {
      case .system: return Color(hex: "EEDFCB")
      case .light:  return Color(hex: "F7F7F9")
      case .dark:   return Color("AppBackground")
      }
    }
    
    private static var appearanceAwareElevated: Color {
      switch AppAppearanceLocal.current() {
      case .system: return Color(hex: "F4E9DA")
      case .light:  return Color(hex: "FAFBFC")
      case .dark:   return Color("Surface")
      }
    }
    
    private static var appearanceAwareCard: Color {
      switch AppAppearanceLocal.current() {
      case .system: return Color(hex: "FCFAF6")
      case .light:  return .white
      case .dark:   return Color("Card")
      }
    }
    
    private static var appearanceAwareStroke: Color {
      switch AppAppearanceLocal.current() {
      case .system: return Color(hex: "E3D6C4")
      case .light:  return Color(hex: "E9EDF2")
      case .dark:   return Color(.separator)
      }
    }
    
    // Shadow opacity guidance
    public static var shadowOpacity: Double {
      switch AppAppearanceLocal.current() {
      case .system: return 0.08
      case .light:  return 0.06
      case .dark:   return 0.20
      }
    }

    // Brand and chat tokens
    public static var brand: Color { Color("Brand") }                 // green for tint
    public static var chatBot: Color { Color("ChatBubbleBot") }       // bot bubble
    public static var chatUser: Color { Color("ChatBubbleUser") }     // user bubble (neutral)

    // Section Accent Colors
    public static var accentTraining: Color  { Color(uiColor: .systemGreen)  }   // Training
    public static var accentNutrition: Color { Color(uiColor: .systemOrange) }   // Nutrition (orange)
    public static var accentRecovery: Color  { Color(uiColor: .systemBlue)   }   // Recovery (blue)
    public static var accentMobility: Color  { Color(uiColor: .systemPurple) }   // Mobility (purple)

    // Primary CTA Colors
    public static var accentPrimary: Color { Color("Brand") }                  // Primary green from assets
    public static var accentSuccess: Color { Color(uiColor: .systemGreen) }    // Success green

    // Utility colors
    public static var black: Color { Color.black }
}

// MARK: - New Theme Manager
public enum EFUserTheme: String, CaseIterable {
    case system, light, dark
}

public final class EFTheme: ObservableObject {
    @AppStorage("ef.colorScheme") private var stored: String = EFUserTheme.system.rawValue
    @Published public var selection: EFUserTheme

    public static let shared = EFTheme()

    private init() {
        let storedValue = UserDefaults.standard.string(forKey: "ef.colorScheme") ?? EFUserTheme.system.rawValue
        selection = EFUserTheme(rawValue: storedValue) ?? .system
    }

    public func set(_ theme: EFUserTheme) {
        selection = theme
        stored = theme.rawValue
    }

    // For SwiftUI .preferredColorScheme binding
    public var preferredScheme: ColorScheme? {
        switch selection {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

// MARK: - New Theme System

enum EFAppearance: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: String { rawValue }
}

final class EFThemeManager: ObservableObject {
    @AppStorage("ef.appearance") var stored: String = EFAppearance.system.rawValue
    var selection: EFAppearance {
        get { EFAppearance(rawValue: stored) ?? .system }
        set { stored = newValue.rawValue; objectWillChange.send() }
    }
    var overrideScheme: ColorScheme? {
        switch selection {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}



final class EFThemeManagerOld: ObservableObject {
    static let shared = EFThemeManagerOld()

    @AppStorage("ef.theme") private var storedTheme: String = EFAppearance.system.rawValue
    @Published var selection: EFAppearance

    var resolvedColorScheme: ColorScheme? {
        switch selection {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    private init() {
        let stored = UserDefaults.standard.string(forKey: "ef.theme") ?? EFAppearance.system.rawValue
        self.selection = EFAppearance(rawValue: stored) ?? .system
    }

    func set(_ theme: EFAppearance) {
        selection = theme
        storedTheme = theme.rawValue
    }
}

// MARK: - App Appearance System
fileprivate enum AppAppearanceLocal: String {
  case system, light, dark
  static func current() -> AppAppearanceLocal {
    let raw = UserDefaults.standard.string(forKey: "display.appearance") ?? "system"
    return AppAppearanceLocal(rawValue: raw) ?? .system
  }
}

// MARK: - NavBlendLocal helper for navigation bar blending
enum NavBlendLocal {
  static func apply() {
    let bg = UIColor(DSColor.canvas)
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = bg
    appearance.shadowColor = .clear
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
  }
}

// MARK: - Primary CTA Style
struct PrimaryCTA: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline.weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(DSColor.accentPrimary)
            .cornerRadius(16)
            .shadow(color: DSColor.accentPrimary.opacity(0.25), radius: 8, y: 4)
    }
}

extension View {
    func primaryCTA() -> some View {
        modifier(PrimaryCTA())
    }
}

// MARK: - Global Nav Bar Styler (shared, internal)
internal enum EFNavBarStyler {
    static func applyCanvasBackground() {
        let bg = UIColor(DSColor.appBackground)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = bg
        appearance.shadowColor = .clear // remove the stripe

        let nav = UINavigationBar.appearance()
        nav.standardAppearance = appearance
        nav.scrollEdgeAppearance = appearance
        nav.compactAppearance = appearance
    }

    static func resetToDefault() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        let nav = UINavigationBar.appearance()
        nav.standardAppearance = appearance
        nav.scrollEdgeAppearance = appearance
        nav.compactAppearance = appearance
    }
}


// Persisted selection
final class ThemeStore: ObservableObject {
    @AppStorage("ef.appearance") var selection: EFAppearance = .system
    static let shared = ThemeStore()
}

// MARK: - Theme palette
enum Theme {
    // Backward compatibility for existing code
    static func palette(_ colorScheme: ColorScheme) -> ThemePalette {
        switch ThemeStore.shared.selection {
        case .system: return colorScheme == .dark ? .dark : .light
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    // Backward compatible palette struct
    struct ThemePalette {
        let background: Color
        let surface: Color
        let surfaceElevated: Color
        let textPrimary: Color
        let textSecondary: Color
        let accent: Color
        let stroke: Color
        
        static let light = ThemePalette(
            background: Color.white,
            surface: Color.white.opacity(0.85),
            surfaceElevated: Color.white,
            textPrimary: Color.black.opacity(0.9),
            textSecondary: Color.black.opacity(0.65),
            accent: Color(red: 0.20, green: 0.70, blue: 0.35),
            stroke: Color.black.opacity(0.08)
        )
        
        static let dark = ThemePalette(
            background: Color(hex: 0x0B0B0D),
            surface: Color(hex: 0x141416),
            surfaceElevated: Color(hex: 0x181A1D),
            textPrimary: .white,
            textSecondary: .white.opacity(0.7),
            accent: Color(hex: 0x2ECC71),
            stroke: .white.opacity(0.06)
        )
    }
  
    // Reuse existing beige (System) tokens – DO NOT change these references.
    static var systemPageBackground: Color { DesignSystem.Colors.backgroundSecondary } // current beige
    static var systemCardBackground: Color { DSColor.card } // whatever the app uses today
    static var systemNavBackground: UIColor { 
        switch AppAppearanceLocal.current() {
        case .system: return UIColor(Color(hex: "EEDFCB"))
        case .light:  return UIColor(Color(hex: "F7F7F9"))
        case .dark:   return UIColor(Color("AppBackground"))
        }
    }

    // New dark tokens (careful: use fixed colors, not system)
    static let darkPageBackground = Color(hex: "0F1113")
    static let darkCardBackground  = Color(hex: "16181A")
    static let darkStroke          = Color.white.opacity(0.06)
    static let darkTextPrimary     = Color(hex: "F2F3F4")
    static let darkTextSecondary   = Color(hex: "A6A9AE")

    // Convenience accessors that switch by current theme
    static var pageBackground: Color {
        switch ThemeStore.shared.selection {
        case .system: return systemPageBackground
        case .light:  return Color.white // placeholder until we do Light
        case .dark:   return darkPageBackground
        }
    }

    static var cardBackground: Color {
        switch ThemeStore.shared.selection {
        case .system: return systemCardBackground
        case .light:  return Color.white // placeholder
        case .dark:   return darkCardBackground
        }
    }

    static var textPrimary: Color {
        switch ThemeStore.shared.selection {
        case .system, .light: return DSColor.textPrimary
        case .dark:           return darkTextPrimary
        }
    }

    static var textSecondary: Color {
        switch ThemeStore.shared.selection {
        case .system, .light: return DSColor.textSecondary
        case .dark:           return darkTextSecondary
        }
    }

    // Nav background UIColor (UIKit)
    static var navBackground: UIColor {
        switch ThemeStore.shared.selection {
        case .system, .light:
            return systemNavBackground
        case .dark:
            return UIColor(Theme.darkPageBackground)
        }
    }
}

// MARK: - Theme applier (UIKit override + notification)
enum ThemeApplier {
    static func apply(_ appearance: EFAppearance) {
        // Make UIKit respect the look (status bar, sheets, etc.)
        let style: UIUserInterfaceStyle = (appearance == .dark) ? .dark : .light
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.overrideUserInterfaceStyle = style }

        // Broadcast so SwiftUI can refresh instantly
        NotificationCenter.default.post(name: .EFThemeChanged, object: appearance)
    }
}

extension Notification.Name {
    static let EFThemeChanged = Notification.Name("EFThemeChanged")
}