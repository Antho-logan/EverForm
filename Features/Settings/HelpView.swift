//
//  HelpView.swift
//  EverForm
//
//  Help and support settings
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("Help")
                .font(.system(.largeTitle, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)

            ScrollView {
                VStack(spacing: 16) {
                    EFCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Frequently Asked Questions").font(.headline)
                            FAQRow(q: "How do I log a meal?", a: "Use Scan → Calorie or the Nutrition quick action.")
                            FAQRow(q: "Can I change units?", a: "Yes, in Profile → Units.")
                            FAQRow(q: "Dark mode?", a: "Settings → Display.")
                        }
                    }
                    EFCard {
                        Button {
                            if let url = URL(string: "mailto:support@everform.app") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("Contact support").bold().frame(maxWidth: .infinity).padding(.vertical, 14)
                        }
                        .buttonStyle(.borderedProminent)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .accessibilityLabel("Contact support by email")
                    }
                    EFCard {
                        Text("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—")")
                            .foregroundStyle(DSColor.textSecondary)
                    }
                }.padding(20)
            }
        }
        .background(DSColor.appBackground.ignoresSafeArea())
    }
}

private struct FAQRow: View {
    let q: String; let a: String
    @State private var open = false
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button {
                withAnimation(.easeInOut) { open.toggle() }
            } label: {
                HStack {
                    Text(q).font(.headline)
                    Spacer()
                    Image(systemName: open ? "chevron.up" : "chevron.down").font(.footnote)
                }
            }
            if open {
                Text(a).foregroundStyle(DSColor.textSecondary)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 6)
    }
}
