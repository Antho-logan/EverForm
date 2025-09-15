import SwiftUI

public enum EFTextRole { case primary, secondary, muted, inverse }

public struct EFTextTokens {
  // Dark
  public let darkPrimary = Color.white
  public let darkSecondary = Color(red: 0.84, green: 0.87, blue: 0.91)   // #D6DEE8 approx
  public let darkMuted = Color(red: 0.65, green: 0.70, blue: 0.75)       // softer
  public let darkInverse = Color.black                                    // for light-on-dark chips

  // Light (leave as current dynamic)
  public let lightPrimary = Color.primary
  public let lightSecondary = Color.secondary
  public let lightMuted = Color.gray.opacity(0.8)
  public let lightInverse = Color.white
}

public final class EFTextTheme: ObservableObject {
  public static let shared = EFTextTheme()
  private let t = EFTextTokens()

  public func color(for role: EFTextRole, scheme: ColorScheme) -> Color {
    let dark = (scheme == .dark)
    switch (role, dark) {
      case (.primary, true):   return t.darkPrimary
      case (.secondary, true): return t.darkSecondary
      case (.muted, true):     return t.darkMuted
      case (.inverse, true):   return t.darkInverse
      case (.primary, false):  return t.lightPrimary
      case (.secondary, false):return t.lightSecondary
      case (.muted, false):    return t.lightMuted
      case (.inverse, false):  return t.lightInverse
    }
  }
}