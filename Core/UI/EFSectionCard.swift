import SwiftUI

struct EFSectionCard<Content: View>: View {
    var content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        VStack(alignment: .leading, spacing: 12) { content }
            .padding(16)
            .background(DSColor.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}

extension View {
    func sectionHeader(_ title: String) -> some View {
        self.overlay(alignment: .topLeading) {
            Text(title).font(.headline).foregroundStyle(DSColor.textPrimary)
        }
    }
}
