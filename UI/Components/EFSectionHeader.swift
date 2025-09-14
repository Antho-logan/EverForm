import SwiftUI

// MARK: - EFSectionHeader Component
public struct EFSectionHeader: View {
    let title: String
    let subtitle: String?
    let icon: String?
    let accentColor: Color?
    let style: HeaderStyle
    
    public enum HeaderStyle {
        case standard
        case card
        case plain
    }
    
    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        accentColor: Color? = nil,
        style: HeaderStyle = .standard
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.accentColor = accentColor
        self.style = style
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: style == .plain ? 4 : 8) {
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(accentColor ?? Color(hex: "0A84FF"))
                        .frame(width: 24, height: 24)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(hex: "FFFFFF"))
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color(hex: "A0A0A0"))
                    }
                }
                
                Spacer()
            }
            
            if style != .plain {
                Divider()
                    .background(Color(hex: "383A3E"))
            }
        }
        .padding(.horizontal, style == .plain ? 20 : 16)
        .padding(.vertical, style == .plain ? 8 : 12)
        .background(
            style == .card ? 
            AnyShapeStyle(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(Color(hex: "232529"))) :
            AnyShapeStyle(Color.clear)
        )
    }
}

// MARK: - Convenience Initializers
extension EFSectionHeader {
    public static func standard(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        accentColor: Color? = nil
    ) -> EFSectionHeader {
        EFSectionHeader(title: title, subtitle: subtitle, icon: icon, accentColor: accentColor, style: .standard)
    }
    
    public static func card(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        accentColor: Color? = nil
    ) -> EFSectionHeader {
        EFSectionHeader(title: title, subtitle: subtitle, icon: icon, accentColor: accentColor, style: .card)
    }
    
    public static func plain(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        accentColor: Color? = nil
    ) -> EFSectionHeader {
        EFSectionHeader(title: title, subtitle: subtitle, icon: icon, accentColor: accentColor, style: .plain)
    }
    
    public static func nutrition(title: String, subtitle: String? = nil) -> EFSectionHeader {
        EFSectionHeader(
            title: title,
            subtitle: subtitle,
            icon: "fork.knife",
            accentColor: Color(hex: "FF9F0A"),
            style: .standard
        )
    }
    
    public static func recovery(title: String, subtitle: String? = nil) -> EFSectionHeader {
        EFSectionHeader(
            title: title,
            subtitle: subtitle,
            icon: "moon.fill",
            accentColor: Color(hex: "BF5AF2"),
            style: .standard
        )
    }
    
    public static func mobility(title: String, subtitle: String? = nil) -> EFSectionHeader {
        EFSectionHeader(
            title: title,
            subtitle: subtitle,
            icon: "figure.flexibility",
            accentColor: Color(hex: "64D2FF"),
            style: .standard
        )
    }
    
    public static func training(title: String, subtitle: String? = nil) -> EFSectionHeader {
        EFSectionHeader(
            title: title,
            subtitle: subtitle,
            icon: "dumbbell.fill",
            accentColor: Color(hex: "32D74B"),
            style: .standard
        )
    }
}

// MARK: - Card Background Extension
extension View {
    func efCardBackground() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(hex: "232529"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(hex: "383A3E"), lineWidth: 0.5)
            )
    }
    
    func efElevatedCardBackground() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(hex: "2A2C30"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(hex: "383A3E"), lineWidth: 0.5)
            )
    }
}