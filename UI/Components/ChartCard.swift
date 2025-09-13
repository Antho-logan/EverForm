import SwiftUI

struct ChartCard<Header: View, ChartArea: View, Footer: View>: View {
    var header: Header
    var chart: ChartArea
    var footer: Footer
    @EnvironmentObject private var appearance: AppearanceStore
    @Environment(\.colorScheme) private var colorScheme

    init(@ViewBuilder header: () -> Header,
         @ViewBuilder chart: () -> ChartArea,
         @ViewBuilder footer: () -> Footer) {
        self.header = header()
        self.chart  = chart()
        self.footer = footer()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            chart
            footer
        }
        .padding(18)
        .background(
            // Subtle depth: gradient + stroke
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(DSColor.card)
                .overlay(
                    LinearGradient(
                        colors: [
                            DSColor.brand.opacity(0.1),
                            DSColor.brand.opacity(0.00)
                        ],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(DSColor.stroke, lineWidth: 1)
                )
        )
        .shadow(color: DSColor.black.opacity(DSColor.shadowOpacity), radius: 14, x: 0, y: 10)
    }
}
