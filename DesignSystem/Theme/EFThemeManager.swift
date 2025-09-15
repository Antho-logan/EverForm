import SwiftUI

enum EFThemeStyle: String { case system, light, dark }

@MainActor
final class EFThemeManager: ObservableObject {
  @Published var style: EFThemeStyle = .system { didSet { applyNavBar() } }
  let tokens = EFColorTokens()

  func isDark(_ scheme: ColorScheme) -> Bool {
    switch style {
      case .dark: return true
      case .light: return false
      case .system: return scheme == .dark
    }
  }
  func apply(style: EFThemeStyle) { self.style = style; applyNavBar() }

  func applyNavBar() {
    let appearance = UINavigationBarAppearance()
    appearance.shadowColor = .clear
    if style == .dark {
      appearance.backgroundColor = UIColor(red: 11/255, green: 14/255, blue: 16/255, alpha: 1)
      appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
      appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    } else {
      appearance.configureWithDefaultBackground()
    }
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }
}

struct EFThemeManagerKey: EnvironmentKey { 
  static let defaultValue = EFThemeManager() 
}

extension EnvironmentValues { 
  var efThemeManager: EFThemeManager {
    get { self[EFThemeManagerKey.self] }
    set { self[EFThemeManagerKey.self] = newValue }
  }
}

extension View {
  func efNavBarBackground(_ color: Color) -> some View {
    self.toolbarBackground(color, for: .navigationBar)
  }
}