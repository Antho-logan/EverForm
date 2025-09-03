//
//  ExportDataView.swift
//  EverForm
//
//  Data export settings
//

import SwiftUI

struct ExportDataView: View {
    @State private var showingShare: Bool = false
    @State private var exportURL: URL?

    var body: some View {
        VStack(spacing: 0) {
            Text("Export Data")
                .font(.system(.largeTitle, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)

            ScrollView {
                VStack(spacing: 16) {
                    EFCard {
                        VStack(spacing: 12) {
                            Text("Choose a format to export your activity data.")
                                .foregroundStyle(DSColor.textSecondary)
                            HStack {
                                Button {
                                    export(.csv)
                                } label: {
                                    Text("Export CSV").bold().frame(maxWidth: .infinity).padding(.vertical, 14)
                                }
                                .buttonStyle(.borderedProminent)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                                Button {
                                    export(.pdf)
                                } label: {
                                    Text("Export PDF").frame(maxWidth: .infinity).padding(.vertical, 14)
                                }
                                .buttonStyle(.bordered)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            }
                        }
                    }
                }.padding(20)
            }
        }
        .background(DSColor.appBackground.ignoresSafeArea())
        .sheet(isPresented: $showingShare) {
            if let url = exportURL {
                ActivityViewController(activityItems: [url])
            }
        }
    }

    enum Format { case csv, pdf }
    private func export(_ format: Format) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let tmp = FileManager.default.temporaryDirectory
        let url = tmp.appendingPathComponent(format == .csv ? "everform_export.csv" : "everform_export.pdf")
        try? "Sample export placeholder\n".write(to: url, atomically: true, encoding: .utf8)
        exportURL = url
        showingShare = true
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController { UIActivityViewController(activityItems: activityItems, applicationActivities: nil) }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
