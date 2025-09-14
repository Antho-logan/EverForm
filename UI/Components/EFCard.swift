import SwiftUI

struct EFCard<Content: View>: View {
    @Environment(\.colorScheme) private var scheme
    var content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(DSColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(DSColor.borderHairline, lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(ThemeManager.shared.scheme == .dark ? 0.4 : 0.1), radius: 12, x: 0, y: 6)
    }
}

struct EFSectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(.title2, weight: .bold))
            .foregroundStyle(DSColor.labelPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }
}
