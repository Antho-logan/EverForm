//
//  DisplaySettingsView.swift
//  EverForm
//
//  Display and appearance settings
//

import SwiftUI

struct DisplaySettingsView: View {
    @ObservedObject private var theme = EFTheme.shared
    @AppStorage("ef.display.reduceMotion") private var reduceMotion = false
    @AppStorage("ef.display.contentSize") private var contentSize: Double = 1.0 // 0.9...1.3

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: "paintpalette.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.green)
                    Text("Display").font(.largeTitle.bold()).foregroundStyle(DSColor.textPrimary)
                    Spacer()
                }.padding(.horizontal, 4)

                EFCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Appearance").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        Picker("", selection: $theme.selection) {
                            Text("System").tag(EFUserTheme.system)
                            Text("Light").tag(EFUserTheme.light)
                            Text("Dark").tag(EFUserTheme.dark)
                        }
                        .pickerStyle(.segmented)
                        Text("Changes apply immediately.").font(.footnote).foregroundStyle(DSColor.textSecondary)
                    }
                }

                EFCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Accessibility").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        Toggle("Reduce motion", isOn: $reduceMotion)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Text size").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                            Slider(value: $contentSize, in: 0.9...1.3, step: 0.05)
                            Text("Current: \(String(format: "%.2fx", contentSize))")
                                .foregroundStyle(DSColor.textSecondary).font(.footnote)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(DSColor.appBackground.ignoresSafeArea())
        .environment(\.sizeCategory, sizeCategory)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var sizeCategory: ContentSizeCategory {
        switch contentSize {
        case ..<0.95: return .small
        case ..<1.05: return .medium
        case ..<1.15: return .large
        default: return .extraLarge
        }
    }
}


