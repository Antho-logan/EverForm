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
            .shadow(color: Color.black.opacity(DSColor.shadowOpacity), radius: 12, x: 0, y: 6)
    }
}

struct EFSectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.system(.title2, weight: .bold))
            .foregroundStyle(DSColor.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }
}
