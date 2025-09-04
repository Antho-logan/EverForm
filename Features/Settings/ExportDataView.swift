//
//  ExportDataView.swift
//  EverForm
//
//  Data export settings
//

import SwiftUI

struct ExportDataView: View {
    @State private var presentShare = false
    @AppStorage("ef.profile.name") private var name: String = ""
    @AppStorage("ef.profile.age") private var age: Int = 29
    @AppStorage("ef.profile.height_cm") private var heightCM: Int = 178
    @AppStorage("ef.profile.weight_kg") private var weightKG: Double = 76
    @AppStorage("ef.profile.units") private var units: String = "Metric"

    var exportPayload: String {
        let dict: [String: Any] = [
            "profile": [
                "name": name, "age": age,
                "height_cm": heightCM, "weight_kg": weightKG,
                "units": units
            ],
            "meta": [
                "exported_at": ISO8601DateFormatter().string(from: Date()),
                "app": "EverForm"
            ]
        ]
        let data = try! JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
        return String(data: data, encoding: .utf8) ?? "{}"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: "square.and.arrow.up.on.square.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.green)
                    Text("Export Data").font(.largeTitle.bold()).foregroundStyle(DSColor.textPrimary)
                    Spacer()
                }.padding(.horizontal, 4)

                EFCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Download your data").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        Text("We'll package profile info and basic app meta into a JSON file. More sources will be added later.")
                            .foregroundStyle(DSColor.textPrimary)

                        Button("Generate & Share JSON") {
                            presentShare = true
                        }
                        .buttonStyle(.borderedProminent)

                    }
                }
            }.padding(16)
        }
        .sheet(isPresented: $presentShare) {
            ShareSheet(items: [exportPayload.data(using: .utf8) as Any, "everform-export.json"])
        }
        .background(DSColor.appBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}
