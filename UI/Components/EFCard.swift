import SwiftUI

struct EFCard<Content: View>: View {
    let content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: EFRadius.card, style: .continuous)

        return content()
            .padding(14)
            .background(
                shape.fill(EFColor.cardIfAvailable)
            )
            .overlay(
                shape.stroke(EFColor.strokeIfAvailable.opacity(0.12), lineWidth: 1)
            )
            .clipShape(shape)
            .compositingGroup()
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

