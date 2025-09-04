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
            VStack(spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.green)
                    Text("Help").font(.largeTitle.bold()).foregroundStyle(DSColor.textPrimary)
                    Spacer()
                }.padding(.horizontal, 4)

                EFCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("FAQ").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        ForEach([
                            "How do I log meals?",
                            "How does dark mode work?",
                            "How to export my data?"
                        ], id: \.self) { q in
                            HStack {
                                Text(q).foregroundStyle(DSColor.textPrimary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(DSColor.textSecondary)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }

                EFCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Support").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        Button {
                            if let url = URL(string: "mailto:support@everform.app?subject=EverForm%20Support") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Label("Email Support", systemImage: "envelope.fill")
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding(16)
        }
        .background(DSColor.appBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}
