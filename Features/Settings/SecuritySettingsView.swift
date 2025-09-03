//
//  SecuritySettingsView.swift
//  EverForm
//
//  Security and authentication settings
//

import SwiftUI

struct SecuritySettingsView: View {
    @State private var useFaceID = true
    @State private var twoFA = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                SettingsSectionCard(title: "Sign-in & Auth") {
                    VStack(spacing: 12) {
                        SettingsRow(icon: "applelogo", title: "Sign in with Apple", subtitle: "Connected") {
                            Image(systemName: "checkmark.seal.fill").foregroundStyle(.green)
                        }
                        SettingsRow(icon: "key.fill", title: "Change Password", subtitle: "If using email login") {
                            Image(systemName: "chevron.right").foregroundStyle(DSColor.textSecondary)
                        }
                        Toggle("Face ID / Touch ID", isOn: $useFaceID)
                            .padding().background(DSColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        Toggle("Two-Factor Authentication", isOn: $twoFA)
                            .padding().background(DSColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }

                SettingsSectionCard(title: "Sessions") {
                    VStack(spacing: 12) {
                        SettingsRow(icon: "iphone.gen3", title: "This iPhone", subtitle: "Active now") { EmptyView() }
                        SettingsRow(icon: "laptopcomputer", title: "MacBook (last week)", subtitle: "Signed out") { EmptyView() }
                        Button(role: .destructive) { /* sign out all - stub */ } label: {
                            Text("Sign Out of All Devices").frame(maxWidth: .infinity)
                        }
                        .padding().background(DSColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Security")
        .background(DSColor.appBackground.ignoresSafeArea())
    }
}
