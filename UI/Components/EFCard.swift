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
    let subtitle: String?
    let icon: String?
    let accentColor: Color?
    
    init(title: String, subtitle: String? = nil, icon: String? = nil, accentColor: Color? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.accentColor = accentColor
    }
    
    var body: some View {
        HStack(spacing: DS.Spacing.sm) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(accentColor ?? EnvironmentValues().efTheme.accent)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(EnvironmentValues().efTheme.textPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(EnvironmentValues().efTheme.textSecondary)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, DS.Spacing.md)
        .padding(.vertical, DS.Spacing.sm)
        .efCardBackground()
    }
}

// MARK: - Convenience Initializers
extension EFSectionHeader {
    static func nutrition(title: String, subtitle: String? = nil) -> EFSectionHeader {
        EFSectionHeader(
            title: title,
            subtitle: subtitle,
            icon: "fork.knife",
            accentColor: EnvironmentValues().efTheme.accentNutrition
        )
    }
    
    static func recovery(title: String, subtitle: String? = nil) -> EFSectionHeader {
        EFSectionHeader(
            title: title,
            subtitle: subtitle,
            icon: "moon.fill",
            accentColor: EnvironmentValues().efTheme.accentRecovery
        )
    }
    
    static func mobility(title: String, subtitle: String? = nil) -> EFSectionHeader {
        EFSectionHeader(
            title: title,
            subtitle: subtitle,
            icon: "figure.flexibility",
            accentColor: EnvironmentValues().efTheme.accentMobility
        )
    }
    
    static func training(title: String, subtitle: String? = nil) -> EFSectionHeader {
        EFSectionHeader(
            title: title,
            subtitle: subtitle,
            icon: "dumbbell.fill",
            accentColor: EnvironmentValues().efTheme.accent
        )
    }
}
