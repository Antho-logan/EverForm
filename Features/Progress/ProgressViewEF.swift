import SwiftUI
#if canImport(Charts)
import Charts
#endif

struct ProgressViewEF: View {
    @StateObject private var store = ProgressStore()

    @Environment(\.horizontalSizeClass) private var hSize
    private var isCompact: Bool { hSize == .compact }

    // Drives chart rebuild + reveal animation
    @State private var chartIdentity: Int = 0
    @State private var reveal: CGFloat = 1.0

    // Sticky header size (for spacing when inset)
    @State private var headerHeight: CGFloat = 0

    // Layout
    private var grid: [GridItem] {
        isCompact ? [GridItem(.flexible())]
                  : [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    }
    private var chartHeight: CGFloat { isCompact ? 220 : 190 }

    var body: some View {
        ZStack {
            Color("AppBackground").ignoresSafeArea()

            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        // Add top padding equal to header height so content doesn't go under the sticky header
                        Color.clear.frame(height: headerHeight)

                        LazyVGrid(columns: grid, spacing: 16) {
                            metricCard(
                                title: "Steps",
                                color: .blue,
                                series: store.series(for: .steps),
                                valueFormatter: { v in "\(Int(v))" }
                            )
                            metricCard(
                                title: "Calories",
                                color: .orange,
                                series: store.series(for: .calories),
                                valueFormatter: { v in "\(Int(v))" }
                            )
                            metricCard(
                                title: "Sleep",
                                color: .purple,
                                series: store.series(for: .sleep),
                                valueFormatter: { v in String(format: "%.1f", v) }
                            )
                            metricCard(
                                title: "Hydration",
                                color: .teal,
                                series: store.series(for: .hydration),
                                valueFormatter: { v in v >= 1000 ? String(format: "%.1fL", v/1000) : "\(Int(v))ml" }
                            )
                        }
                        .animation(.snappy(duration: 0.45, extraBounce: 0.04), value: store.range)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                    }
                }
                .background(DSColor.appBackground.ignoresSafeArea())
                .toolbar(.hidden, for: .navigationBar)
                .safeAreaInset(edge: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Progress")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(DSColor.textPrimary)

                        Picker("", selection: $store.range) {
                            Text("Day").tag(ProgressRange.day)
                            Text("Week").tag(ProgressRange.week)
                            Text("Month").tag(ProgressRange.month)
                        }
                        .labelsHidden()
                        .pickerStyle(.segmented)
                        .background(DSColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .frame(width: isCompact ? 260 : 320)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 8)
                    .background(DSColor.appBackground)
                    .readSize { headerHeight = $0.height }
                }
                .onAppear {
                    store.regenerate()
                    startRevealAnimation()
                }
                .onChange(of: store.range) {
                    withAnimation(.snappy(duration: 0.45, extraBounce: 0.04)) {
                        chartIdentity &+= 1
                    }
                    store.regenerate()
                    startRevealAnimation()
                }
            }
        }
    }



    // MARK: - Cards

    @ViewBuilder
    private func metricCard(title: String, color: Color, series: EFMetricSeries, valueFormatter: (Double)->String) -> some View {
        let latest = series.points.last?.value ?? 0

        ChartCard {
            HStack {
                Text(title).font(.headline).foregroundStyle(DSColor.textPrimary)
                Spacer()
                Text(valueFormatter(latest))
                    .font(.title3.monospacedDigit()).bold()
                    .foregroundStyle(DSColor.textPrimary)
                    .contentTransition(.numericText())
            }
        } chart: {
            #if canImport(Charts)
            Chart(series.points) { p in
                LineMark(
                    x: .value("Date", p.date),
                    y: .value("Value", p.value)
                )
                .interpolationMethod(.monotone)
                .lineStyle(StrokeStyle(lineWidth: 2.6, lineCap: .round, lineJoin: .round))
                .foregroundStyle(color.opacity(0.9))

                AreaMark(
                    x: .value("Date", p.date),
                    y: .value("Value", p.value)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(color.opacity(0.18))
            }
            .chartXAxis(.automatic)
            .chartYAxis(.automatic)
            .frame(minHeight: chartHeight)
            .id(chartIdentity)

            // LEFT→RIGHT REVEAL: mask scales from 0→1 with animation
            .mask(
                GeometryReader { geo in
                    Rectangle()
                        .frame(width: max(1, geo.size.width * reveal), height: geo.size.height)
                        .alignmentGuide(.leading) { d in d[.leading] }
                        .animation(.easeOut(duration: 0.75), value: reveal)
                }
            )
            #else
            ZStack {
                RoundedRectangle(cornerRadius: 12).fill(DSColor.surface)
                Text("Charts framework not available")
                    .foregroundStyle(DSColor.textSecondary)
                    .font(.footnote)
            }
            .frame(minHeight: chartHeight)
            #endif
        } footer: {
            HStack(spacing: 8) {
                Circle().fill(color.opacity(0.9)).frame(width: 8, height: 8)
                Text(series.unit).foregroundStyle(DSColor.textSecondary).font(.footnote)
                Spacer()
                Text(labelForRange(store.range)).foregroundStyle(DSColor.textSecondary).font(.footnote)
            }
        }
    }

    private func labelForRange(_ r: ProgressRange) -> String {
        switch r {
        case .day:   return "Today"
        case .week:  return "Last 7 days"
        case .month: return "Last 30 days"
        case .quarter: return "Last 90 days"
        }
    }

    // MARK: - Animation

    private func startRevealAnimation() {
        reveal = 0.0
        withAnimation(.easeOut(duration: 0.75)) {
            reveal = 1.0
        }
    }
}

private extension View {
    // Utility to read rendered size
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: SizePrefKey.self, value: geo.size)
            }
        )
        .onPreferenceChange(SizePrefKey.self, perform: onChange)
    }
}

private struct SizePrefKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
