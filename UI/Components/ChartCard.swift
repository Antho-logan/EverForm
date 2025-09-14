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
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(DSColor.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(DSColor.borderHairline, lineWidth: 0.5)
                )
        )
        .shadow(color: Color.black.opacity(ThemeManager.shared.scheme == .dark ? 0.4 : 0.1), radius: 14, x: 0, y: 10)
    }
}
