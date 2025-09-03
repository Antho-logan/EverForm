//
//  DisplaySettingsView.swift
//  EverForm
//
//  Display and appearance settings
//

import SwiftUI

struct DisplaySettingsView: View {
    @ObservedObject private var theme = EFTheme.shared
    @AppStorage("ef.textScale") private var textScale: Double = 1.0
    @AppStorage("ef.compactCards") private var compactCards: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            Text("Display")
                .font(.system(.largeTitle, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)

            ScrollView {
                VStack(spacing: 16) {
                    EFCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Appearance").font(.headline)
                            Picker("", selection: $theme.selection) {
                                Text("System").tag(EFUserTheme.system)
                                Text("Light").tag(EFUserTheme.light)
                                Text("Dark").tag(EFUserTheme.dark)
                            }
                            .pickerStyle(.segmented)
                            .padding(.top, 8)
                            Text("This overrides the app's appearance immediately.")
                                .font(.footnote).foregroundStyle(DSColor.textSecondary)
                        }
                    }
                    EFCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Text size").font(.headline)
                            HStack {
                                Image(systemName: "textformat.size.smaller")
                                Slider(value: $textScale, in: 0.9...1.3, step: 0.05)
                                Image(systemName: "textformat.size.larger")
                            }
                            .onChange(of: textScale) { _, v in
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            }
                            Toggle("Compact cards", isOn: $compactCards)
                        }
                    }
                }
                .padding(20)
            }
        }
        .environment(\.sizeCategory, sizeCategory(from: textScale))
        .background(DSColor.appBackground.ignoresSafeArea())
    }

    private func sizeCategory(from scale: Double) -> ContentSizeCategory {
        if scale < 0.95 { return .small }
        if scale < 1.05 { return .medium }
        if scale < 1.15 { return .large }
        return .extraLarge
    }
}


