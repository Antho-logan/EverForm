//
//  SecuritySettingsView.swift
//  EverForm
//
//  Security and authentication settings
//

import SwiftUI
import LocalAuthentication

struct SecuritySettingsView: View {
    @AppStorage("sec.requireBio") private var requireBio: Bool = false
    @AppStorage("sec.hideTiles") private var hideTiles: Bool = false
    @AppStorage("sec.requireBioForCoach") private var requireCoachBio: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Text("Security")
                .font(.system(.largeTitle, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)

            ScrollView {
                VStack(spacing: 16) {
                    EFCard {
                        VStack(spacing: 12) {
                            Toggle("Require Face ID / Touch ID to open app", isOn: $requireBio)
                            Toggle("Require biometrics before sending Coach messages", isOn: $requireCoachBio)
                            Toggle("Hide sensitive tiles on Overview", isOn: $hideTiles)
                        }
                    }
                    EFCard {
                        HStack {
                            Image(systemName: "info.circle")
                            Text(bioAvailable() ? "Biometrics available" : "Biometrics not available")
                            Spacer()
                        }.foregroundStyle(DSColor.textSecondary)
                    }
                }.padding(20)
            }
        }
        .background(DSColor.appBackground.ignoresSafeArea())
    }

    private func bioAvailable() -> Bool {
        var err: NSError?
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err)
    }
}
