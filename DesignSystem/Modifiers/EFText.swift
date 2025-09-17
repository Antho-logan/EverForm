import SwiftUI

// This file is now deprecated - use UI/Theme/EFTextTheme.swift instead
// The canonical EFTextRole and efText() implementation is in UI/Theme/EFTextTheme.swift

@available(*, deprecated, renamed: "EFText", message: "Use UI/Theme/EFTextTheme.swift instead")
public struct EFTextColor: ViewModifier {
  @Environment(\.colorScheme) private var scheme
  let role: EFTextRole
  public func body(content: Content) -> some View {
    content.foregroundStyle(EFTextTheme.color(for: role, scheme: scheme))
  }
}

public extension View {
  @available(*, deprecated, renamed: "efText", message: "Use UI/Theme/EFTextTheme.swift instead")
  func efTextLegacy(_ role: EFTextRole = .primary) -> some View {
    self.modifier(EFTextColor(role: role))
  }
}