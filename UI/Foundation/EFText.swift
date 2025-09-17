import SwiftUI

// Legacy compatibility - this file now delegates to the canonical EFTextTheme
// The main EFTextRole and efText() implementation is in UI/Theme/EFTextTheme.swift

public struct EFTextColor: ViewModifier {
  @Environment(\.efTextTheme) private var theme
  let role: EFTextRole
  public func body(content: Content) -> some View {
    content.foregroundStyle(colorForRole(role))
  }
  
  // Map EFTextRole to our centralized theme colors
  private func colorForRole(_ role: EFTextRole) -> Color {
    switch role {
    case .primary:
      return theme.headerPrimary
    case .secondary:
      return theme.headerSecondary
    case .muted:
      return theme.headerSecondary.opacity(0.6)
    case .inverse:
      return theme.headerPrimary
    case .header:
      return theme.headerPrimary
    }
  }
}