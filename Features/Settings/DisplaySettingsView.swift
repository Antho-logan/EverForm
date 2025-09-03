//
//  DisplaySettingsView.swift
//  EverForm
//
//  Display and appearance settings
//

import SwiftUI

struct DisplaySettingsView: View {
    @ObservedObject private var theme = EFTheme.shared
    @State private var textSize: Double = 0 // 0=default, 1=+1, 2=+2
    @State private var reduceMotion = false
    @State private var haptics = true
    @State private var cardDensity = 0 // 0 comfortable, 1 compact

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                SettingsSectionCard(title: "Appearance") {
                    HStack(spacing: 12) {
                        ForEach([EFUserTheme.system, .light, .dark], id: \.rawValue) { opt in
                            Button {
                                theme.set(opt)
                            } label: {
                                Text(opt.rawValue.capitalized)
                                    .fontWeight(theme.selection == opt ? .semibold : .regular)
                                    .padding(.vertical, 10).frame(maxWidth: .infinity)
                                    .background(theme.selection == opt ? DSColor.cardElevated : DSColor.surface)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                        }
                    }
                }

                SettingsSectionCard(title: "Interface") {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Text Size").foregroundStyle(DSColor.textPrimary)
                            Spacer()
                            Slider(value: $textSize, in: 0...2, step: 1)
                                .frame(width: 160)
                        }
                        .padding().background(DSColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        Picker("Card Density", selection: $cardDensity) {
                            Text("Comfortable").tag(0)
                            Text("Compact").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .padding().background(DSColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        Toggle("Haptics", isOn: $haptics)
                            .padding().background(DSColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        Toggle("Reduce Motion", isOn: $reduceMotion)
                            .padding().background(DSColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Display")
        .background(DSColor.appBackground.ignoresSafeArea())
    }
}
