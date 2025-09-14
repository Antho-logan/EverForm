import SwiftUI

/// Minimal card style used by legacy call sites like `.efCardStyle(scheme:)`.
/// Visuals intentionally neutral (system colors) so we don't alter branding.
/// Replace later with your design tokens once the build is green.
private struct EFCardModifier: ViewModifier {
    let scheme: ColorScheme?

    @Environment(\.colorScheme) private var systemScheme

    private var isDark: Bool { (scheme ?? systemScheme) == .dark }

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isDark ? Color(.secondarySystemBackground)
                                 : Color(.systemBackground))
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                // Subtle border to match platform cards; harmless in both modes.
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.black.opacity(isDark ? 0.20 : 0.06), lineWidth: 1)
            )
    }
}

public extension View {
    /// Shim so existing code compiles: `.efCardStyle(scheme: ...)`
    func efCardStyle(scheme: ColorScheme? = nil) -> some View {
        modifier(EFCardModifier(scheme: scheme))
    }
}