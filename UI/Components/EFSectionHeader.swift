import SwiftUI
struct EFSectionHeader: View {
    let title: String; let subtitle: String?
    init(_ title: String, subtitle: String? = nil) { self.title = title; self.subtitle = subtitle }
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.headline).foregroundStyle(DSColor.textPrimary)
            if let s = subtitle, !s.isEmpty {
                Text(s).font(.subheadline).foregroundStyle(DSColor.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}