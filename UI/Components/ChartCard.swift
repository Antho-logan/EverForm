import SwiftUI

struct ChartCard<Header: View, ChartArea: View, Footer: View>: View {
    var header: Header
    var chart: ChartArea
    var footer: Footer

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
                            Color.white.opacity(0.06),
                            Color.white.opacity(0.00)
                        ],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.10), radius: 14, x: 0, y: 10)
    }
}
