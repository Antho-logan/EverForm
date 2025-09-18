import SwiftUI

struct EFCard<Content: View>: View {
    let content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    var body: some View {
        content()
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: EFRadius.card, style: .continuous)
                    .fill(EFColor.cardIfAvailable)
            )
            .overlay(
                RoundedRectangle(cornerRadius: EFRadius.card, style: .continuous)
                    .stroke(EFColor.strokeIfAvailable.opacity(0.7), lineWidth: 1)
            )
    }
}

// Use palette shim in System mode if assets aren't present.
private extension EFColor {
    static var cardIfAvailable: Color {
        #if canImport(SwiftUI)
        return EFPaletteLight.card ?? EFColor.card
        #else
        return EFColor.card
        #endif
    }
    static var strokeIfAvailable: Color {
        #if canImport(SwiftUI)
        return EFPaletteLight.stroke ?? EFColor.stroke
        #else
        return EFColor.stroke
        #endif
    }
}

