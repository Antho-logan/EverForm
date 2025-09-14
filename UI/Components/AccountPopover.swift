import SwiftUI

struct AccountPopover: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Circle()
                    .fill(EFColor.green.opacity(0.2))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(EFColor.green)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text("Alex Chen")
                        .font(.headline)
                        .foregroundColor(EFColor.textLight)
                    Text("alex@example.com")
                        .font(.subheadline)
                        .foregroundStyle(EFColor.subTextLight)
                }
            }
            .padding(16)

            Divider()
                .background(EFColor.dividerLight)

            MenuRow(icon: "person.circle", title: "Profile", trailing: EmptyView())
            MenuRow(icon: "paintbrush", title: "Display", trailing: Text(currentThemeLabel()).foregroundStyle(EFColor.subTextLight))
            MenuRow(icon: "lock", title: "Security", trailing: EmptyView())
            MenuRow(icon: "square.and.arrow.down", title: "Export Data", trailing: EmptyView())
            MenuRow(icon: "questionmark.circle", title: "Help", trailing: EmptyView())
            MenuRow(icon: "ladybug", title: "Report a Bug", trailing: EmptyView())
        }
        .background(EFColor.surfaceLight)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(EFColor.dividerLight))
        .padding(.vertical, 4)
        .frame(maxWidth: 320)
    }

    private func currentThemeLabel() -> String {
        themeManager.selectedTheme.displayName
    }
}

private struct MenuRow<Trailing: View>: View {
    let icon: String
    let title: String
    var trailing: Trailing
    
    init(icon: String, title: String, trailing: Trailing = EmptyView() as! Trailing) {
        self.icon = icon
        self.title = title
        self.trailing = trailing
    }
    
    var body: some View {
        Button(action: {
            // Handle menu item tap
        }) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 22)
                    .foregroundStyle(EFColor.subTextLight)

                Text(title)
                    .foregroundColor(EFColor.textLight)

                Spacer()

                trailing

                Image(systemName: "chevron.right")
                    .foregroundStyle(EFColor.subTextLight.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}
