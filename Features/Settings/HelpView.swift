//
//  HelpView.swift
//  EverForm
//
//  Help and support settings
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                SettingsSectionCard(title: "Get Help") {
                    VStack(spacing: 12) {
                        SettingsRow(icon: "questionmark.circle.fill", title: "FAQ", subtitle: "Common questions") {
                            Image(systemName: "chevron.right").foregroundStyle(DSColor.textSecondary)
                        }
                        SettingsRow(icon: "envelope.fill", title: "Contact Support", subtitle: "support@everform.app") {
                            Image(systemName: "arrow.up.right").foregroundStyle(DSColor.textSecondary)
                        }
                        SettingsRow(icon: "doc.text.fill", title: "Terms & Privacy", subtitle: nil) {
                            Image(systemName: "chevron.right").foregroundStyle(DSColor.textSecondary)
                        }
                    }
                }
                SettingsSectionCard(title: "Diagnostics") {
                    Toggle("Include anonymous logs in bug reports", isOn: .constant(false))
                        .padding().background(DSColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
            .padding(20)
        }
        .navigationTitle("Help")
        .background(DSColor.appBackground.ignoresSafeArea())
    }
}
