//
//  ExportDataView.swift
//  EverForm
//
//  Data export settings
//

import SwiftUI

struct ExportDataView: View {
    enum Format: String, CaseIterable, Identifiable { case csv, json; var id: String { rawValue } }
    @State private var format: Format = .csv
    @State private var include = Set<String>(["Workouts","Meals","Hydration","Sleep","Chat"])
    @State private var start = Calendar.current.date(byAdding: .day, value: -30, to: .now) ?? .now
    @State private var end = Date()
    @State private var emailed = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                SettingsSectionCard(title: "Range & Format") {
                    VStack(spacing: 12) {
                        DatePicker("Start", selection: $start, displayedComponents: .date)
                            .padding().background(DSColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        DatePicker("End", selection: $end, displayedComponents: .date)
                            .padding().background(DSColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        Picker("Format", selection: $format) {
                            Text("CSV").tag(Format.csv)
                            Text("JSON").tag(Format.json)
                        }
                        .pickerStyle(.segmented)
                        .padding().background(DSColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }

                SettingsSectionCard(title: "Include Data") {
                    VStack(spacing: 10) {
                        ForEach(["Workouts","Meals","Hydration","Sleep","Chat"], id: \.self) { item in
                            Toggle(item, isOn: Binding(
                                get: { include.contains(item) },
                                set: { if $0 { include.insert(item) } else { include.remove(item) } }
                            ))
                            .padding().background(DSColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                }

                Button {
                    // stub export action
                } label: {
                    Text("Export").fontWeight(.semibold).frame(maxWidth: .infinity)
                }
                .padding(16).background(DSColor.cardElevated)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                Button {
                    emailed = true
                } label: {
                    Text("Email me a copy").frame(maxWidth: .infinity)
                }
                .padding(14).background(DSColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .alert("Export queued", isPresented: $emailed) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("We'll email a download link when it's ready.")
                }
            }
            .padding(20)
        }
        .navigationTitle("Export Data")
        .background(DSColor.appBackground.ignoresSafeArea())
    }
}
