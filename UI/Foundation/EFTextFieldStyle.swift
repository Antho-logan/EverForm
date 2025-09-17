import SwiftUI

// MARK: - EFTextFieldStyle for Glamorous Dark Text Fields
public struct EFTextFieldStyle: TextFieldStyle {
    let isDarkGlamorous: Bool
    
    public init(isDarkGlamorous: Bool = false) {
        self.isDarkGlamorous = isDarkGlamorous
    }
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isDarkGlamorous ? Color(hex: "2A2C30") : Color(hex: "232529"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isDarkGlamorous ? Color(hex: "0A84FF").opacity(0.3) : Color(hex: "383A3E"), lineWidth: 1)
            )
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.primary)
            .accentColor(Color(hex: "0A84FF"))
    }
}

// MARK: - Convenience Extension
extension TextFieldStyle where Self == EFTextFieldStyle {
    static var darkGlamorous: EFTextFieldStyle {
        EFTextFieldStyle(isDarkGlamorous: true)
    }
    
    static var darkStandard: EFTextFieldStyle {
        EFTextFieldStyle(isDarkGlamorous: false)
    }
}

// MARK: - Dark Glamorous Text Editor Modifier
extension View {
    func darkGlamorousTextFieldStyle() -> some View {
        self
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(hex: "2A2C30"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(hex: "0A84FF").opacity(0.3), lineWidth: 1)
            )
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.primary)
            .accentColor(Color(hex: "0A84FF"))
    }
}