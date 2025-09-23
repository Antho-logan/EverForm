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

    @State private var showProfileMenu = false

    var body: some View {
        ZStack(alignment: .center) {
            // Centered title
            Text(title)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(DSColor.textPrimary)

            // Row for leading controls
            HStack(spacing: 12) {
                // Left avatar button – larger and matching popover avatar style
                ProfileAvatarButton(size: 36) {
                    showProfileMenu.toggle()
                }
                .accessibilityIdentifier("overview.avatarButton")
                .popover(
                    isPresented: $showProfileMenu,
                    attachmentAnchor: .rect(.bounds),
                    arrowEdge: .top
                ) {
                    ProfileMenuPopover(
                        onProfile: onProfile,
                        onDisplay: onDisplay,
                        onSecurity: onSecurity,
                        onExport: onExport,
                        onHelp: onHelp,
                        onReport: onReport,
                        onDismiss: { showProfileMenu = false }
                    )
                    .presentationCompactAdaptation(.popover)
                    .frame(width: 300)
                }

                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, EFSpacing.page)
        .padding(.bottom, 6)
        .background(DSColor.bg)
        .zIndex(10)
    }
}