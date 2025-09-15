import SwiftUI

public struct EFTextColor: ViewModifier {
  @Environment(\.colorScheme) private var scheme
  let role: EFTextRole
  public func body(content: Content) -> some View {
    content.foregroundStyle(EFTextTheme.shared.color(for: role, scheme: scheme))
  }
}

public extension View {
  func efText(_ role: EFTextRole = .primary) -> some View {
    self.modifier(EFTextColor(role: role))
  }
}