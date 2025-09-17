import SwiftUI

// MARK: - Header Styling ViewModifier
struct EFHeaderTitle: ViewModifier {
    @Environment(\.efTextTheme) private var theme
    
    func body(content: Content) -> some View {
        content
            .font(.system(.title2, design: .rounded).weight(.bold))
            .foregroundStyle(theme.headerPrimary)
            .padding(.horizontal, 16)
            .padding(.top, 6)
            .padding(.bottom, 4)
    }
}

// MARK: - View Extension
extension View {
    func efHeaderTitle() -> some View {
        modifier(EFHeaderTitle())
    }
}