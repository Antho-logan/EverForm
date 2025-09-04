//
//  SettingsScaffold.swift
//  EverForm
//
//  Reusable components for settings screens
//

import SwiftUI

struct SettingsSectionCard<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline).foregroundStyle(DSColor.textPrimary)
                .padding(.horizontal, 8)
            VStack(spacing: 12) { content }
                .padding(16)
                .background(DSColor.card)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.black.opacity(ColorScheme.current == .light ? 0.06 : 0), radius: 12, x: 0, y: 6)
        }
    }
}

struct SettingsRow<Right: View>: View {
    let icon: String
    let title: String
    let subtitle: String?
    @ViewBuilder var right: Right
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 32, height: 32)
                .background(DSColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).foregroundStyle(DSColor.textPrimary)
                if let subtitle { Text(subtitle).font(.subheadline).foregroundStyle(DSColor.textSecondary) }
            }
            Spacer()
            right
        }
        .padding(14)
        .background(DSColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private extension ColorScheme {
    static var current: UIUserInterfaceStyle {
        UITraitCollection.current.userInterfaceStyle
    }
}
