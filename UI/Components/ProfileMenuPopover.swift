import SwiftUI

/// Lightweight theme fallbacks in case Theme isn't present everywhere
fileprivate extension Color {
    static var cardBg: Color { Color(.secondarySystemBackground) }
    static var surfaceElevated: Color { Color(.systemGray6) }
    static var onSurface: Color { Color.primary }
    static var subtle: Color { Color.secondary }
    static var accentGreen: Color { Color(hue: 0.33, saturation: 0.6, brightness: 0.75) }
}

/// A floating popover card that anchors to a given rect in global coordinates.
struct ProfileMenuPopover: View {
    struct Item: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let trailing: String?
        let action: () -> Void
    }

    var onProfile: () -> Void
    var onDisplay: () -> Void
    var onSecurity: () -> Void
    var onExport: () -> Void
    var onHelp: () -> Void
    var onReport: () -> Void

    let onDismiss: () -> Void
    var name: String = "User"
    var email: String = "user@example.com"

    @State private var appear = false
    @Environment(\.colorScheme) private var colorScheme

    private var items: [Item] {
        [
            .init(icon: "person.crop.circle", title: "Profile", trailing: nil, action: onProfile),
            .init(icon: "paintbrush",         title: "Display", trailing: nil, action: onDisplay),
            .init(icon: "lock.shield",        title: "Security", trailing: nil, action: onSecurity),
            .init(icon: "square.and.arrow.up",title: "Export Data", trailing: nil, action: onExport),
            .init(icon: "questionmark.circle",title: "Help", trailing: nil, action: onHelp),
            .init(icon: "ant.fill",           title: "Report a Bug", trailing: nil, action: onReport)
        ]
    }

    /// Layout constants
    private let cardWidth: CGFloat = 300
    private let cardPadding: CGFloat = 12
    private let corner: CGFloat = 16

    var body: some View {
        VStack(spacing: 0) {
            // Card
            VStack(spacing: 0) {
                    // Header
                    HStack(spacing: 12) {
                        ZStack {
                            Circle().fill(Color.accentGreen.opacity(0.2))
                            Image(systemName: "person.fill")
                                .foregroundStyle(Color.accentGreen)
                        }
                        .frame(width: 36, height: 36)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(name).font(.headline)
                            Text(email).font(.subheadline).foregroundStyle(Color.subtle)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)

                    Divider().opacity(0.35)

                    // Items
                    VStack(spacing: 0) {
                        ForEach(items) { item in
                            Button(action: {
                                item.action()
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                    appear = false
                                    onDismiss()
                                }
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: item.icon)
                                        .frame(width: 22)
                                    Text(item.title)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    if let trailing = item.trailing {
                                        Text(trailing).foregroundStyle(Color.subtle)
                                    }
                                    Image(systemName: "chevron.right")
                                        .font(.footnote)
                                        .foregroundStyle(Color.subtle)
                                }
                                .padding(.horizontal, 12)
                                .frame(height: 48)
                            }
                            .buttonStyle(.plain)
                            if item.id != items.last?.id {
                                Divider().opacity(0.2)
                            }
                        }
                    }
                }
                .background(EFPalette.current(colorScheme).chrome, in: RoundedRectangle(cornerRadius: corner, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: corner, style: .continuous)
                        .stroke(EFPalette.current(colorScheme).stroke, lineWidth: colorScheme == .light ? 1 : 0)
                )
                .shadow(color: EFPalette.current(colorScheme).shadow, radius: colorScheme == .light ? 18 : 12, x: 0, y: colorScheme == .light ? 12 : 8)
            }
            .frame(width: cardWidth)
            .onAppear { appear = true }
            .accessibilityAddTraits(.isModal)
        }
    }
