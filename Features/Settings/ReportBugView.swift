//
//  ReportBugView.swift
//  EverForm
//
//  Bug reporting interface
//

import SwiftUI
import UniformTypeIdentifiers

struct ReportBugView: View {
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var includeLogs: Bool = true
    @State private var showCopied: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Text("Report a Bug")
                .font(.system(.largeTitle, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)

            ScrollView {
                VStack(spacing: 16) {
                    EFCard {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Title").frame(width: 110, alignment: .leading)
                                TextField("Title", text: $title)
                                    .textFieldStyle(.plain)
                                    .padding(.horizontal, 12).padding(.vertical, 10)
                                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                            Divider()
                            VStack(alignment: .leading) {
                                Text("Details").font(.headline)
                                TextEditor(text: $details)
                                    .frame(minHeight: 120)
                                    .padding(12)
                                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                            Toggle("Include anonymized logs", isOn: $includeLogs)
                        }
                    }
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        let body = """
                        [Bug] \(title)

                        Details:
                        \(details)

                        Include logs: \(includeLogs ? "Yes" : "No")
                        """
                        UIPasteboard.general.setValue(body, forPasteboardType: UTType.utf8PlainText.identifier)
                        showCopied = true
                    } label: {
                        Text("Send").bold().frame(maxWidth: .infinity).padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .alert("Copied bug report to clipboard", isPresented: $showCopied) { Button("OK", role: .cancel) {} }
                }
                .padding(20)
            }
        }
        .background(DSColor.appBackground.ignoresSafeArea())
    }
}
