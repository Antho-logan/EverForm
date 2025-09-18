import SwiftUI

struct OverviewHeader: View {
    let title: String
    @Binding var showMenu: Bool
    var onTapProfile: () -> Void
    var onProfile: () -> Void
    var onDisplay: () -> Void
    var onSecurity: () -> Void
    var onExport: () -> Void
    var onHelp: () -> Void
    var onReport: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onTapProfile) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .symbolRenderingMode(.multicolor)
                    .accessibilityLabel("Profile")
            }
            .popover(
                isPresented: $showMenu,
                attachmentAnchor: .rect(.bounds),
                arrowEdge: .top
            ) {
                ProfileMenuPopover(
                    anchorRect: .zero,
                    safeBounds: UIScreen.main.bounds,
                    onDismiss: { showMenu = false },
                    name: "User",
                    email: "user@example.com",
                    onProfile: onProfile,
                    onDisplay: onDisplay,
                    onSecurity: onSecurity,
                    onExport: onExport,
                    onHelp: onHelp,
                    onReport: onReport
                )
                .frame(width: 250, height: 400)
            }

            Text(title)
                .font(.system(size: 34, weight: .bold))
                .tracking(-0.3)

            Spacer()
        }
        .contentShape(Rectangle())
    }
}