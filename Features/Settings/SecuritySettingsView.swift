//
//  SecuritySettingsView.swift
//  EverForm
//
//  Security and authentication settings
//

import SwiftUI

struct SecuritySettingsView: View {
    @AppStorage("ef.security.faceid") private var useFaceID = false
    @AppStorage("ef.security.biometricTips") private var showTips = true

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.green)
                    Text("Security").font(.largeTitle.bold()).foregroundStyle(DSColor.textPrimary)
                    Spacer()
                }.padding(.horizontal, 4)

                EFCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Authentication").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        Toggle("Face ID / Touch ID", isOn: $useFaceID)
                        Text("Biometric toggle UI only — hook actual auth later.")
                            .font(.footnote).foregroundStyle(DSColor.textSecondary)
                    }
                }

                EFCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Privacy").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        Toggle("Show security tips", isOn: $showTips)
                        Text("We never sell data. See Export Data to download or delete.")
                            .foregroundStyle(DSColor.textPrimary)
                    }
                }
            }.padding(16)
        }
        .background(DSColor.appBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}
