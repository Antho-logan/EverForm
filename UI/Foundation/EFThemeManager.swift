import SwiftUI

enum EFThemeStyle: String { case system, light, dark }

final class EFThemeManager: ObservableObject, @unchecked Sendable {
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
    // Use the centralized navigation bar appearance system
    let scheme: ColorScheme = style == .dark ? .dark : .light
    EFNavBarAppearance.apply(for: scheme)
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