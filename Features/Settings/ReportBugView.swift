//
//  ReportBugView.swift
//  EverForm
//
//  Bug reporting interface
//

import SwiftUI

struct ReportBugView: View {
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var includeScreenshot = false
    @State private var sent = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                SettingsSectionCard(title: "Describe the issue") {
                    VStack(spacing: 12) {
                        TextField("Short title", text: $title)
                            .padding().background(DSColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        TextEditor(text: $details)
                            .frame(minHeight: 140)
                            .padding(8).background(DSColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        Toggle("Attach recent screenshot (if available)", isOn: $includeScreenshot)
                            .padding().background(DSColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }

                Button {
                    sent = true
                } label: {
                    Text("Send Report").fontWeight(.semibold).frame(maxWidth: .infinity)
                }
                .padding(16).background(DSColor.cardElevated)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .alert("Thanks!", isPresented: $sent) {
                    Button("OK") { }
                } message: {
                    Text("Your report was submitted. We'll take a look soon.")
                }
            }
            .padding(20)
        }
        .navigationTitle("Report a Bug")
        .background(DSColor.appBackground.ignoresSafeArea())
    }
}
