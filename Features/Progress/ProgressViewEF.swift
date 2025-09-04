import SwiftUI
#if canImport(Charts)
import Charts
#endif

struct ProgressViewEF: View {
    @StateObject private var store = ProgressStore()
    private let grid = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                HStack {
                    Text("Progress").font(.largeTitle.bold()).foregroundStyle(DSColor.textPrimary)
                    Spacer()
                    Picker("", selection: $store.range) {
                        Text("Day").tag(ProgressRange.day)
                        Text("Week").tag(ProgressRange.week)
                        Text("Month").tag(ProgressRange.month)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 260)
                }
                .padding(.horizontal, 4)

                LazyVGrid(columns: grid, spacing: 16) {
                    metricCard(
                        title: "Steps",
                        color: .blue,
                        data: generateStepsData(),
                        unit: "steps",
                        valueFormatter: { v in "\(Int(v))" }
                    )
                    metricCard(
                        title: "Calories",
                        color: .orange,
                        data: generateCaloriesData(),
                        unit: "kcal",
                        valueFormatter: { v in "\(Int(v))" }
                    )
                    metricCard(
                        title: "Sleep",
                        color: .purple,
                        data: generateSleepData(),
                        unit: "h",
                        valueFormatter: { v in String(format: "%.1f", v) }
                    )
                    metricCard(
                        title: "Hydration",
                        color: .teal,
                        data: generateHydrationData(),
                        unit: "ml",
                        valueFormatter: { v in v >= 1000 ? String(format: "%.1fL", v/1000) : "\(Int(v))ml" }
                    )
                }
            }
            .padding(16)
        }
        .background(DSColor.appBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func metricCard(title: String, color: Color, data: [ProgressPoint], unit: String, valueFormatter: @escaping (Double)->String) -> some View {
        let latest = data.last?.value ?? 0
        EFCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title).font(.headline).foregroundStyle(DSColor.textPrimary)
                    Spacer()
                    Text(valueFormatter(latest))
                        .font(.title3.monospacedDigit()).bold()
                        .foregroundStyle(DSColor.textPrimary)
                }

                #if canImport(Charts)
                Chart(data) { p in
                    LineMark(
                        x: .value("Date", p.date),
                        y: .value("Value", p.value)
                    )
                    .interpolationMethod(.monotone)
                    .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(color.opacity(0.85))

                    AreaMark(
                        x: .value("Date", p.date),
                        y: .value("Value", p.value)
                    )
                    .interpolationMethod(.monotone)
                    .foregroundStyle(color.opacity(0.18))
                }
                .chartXAxis(.automatic)
                .chartYAxis(.automatic)
                .frame(minHeight: 140)
                #else
                ZStack {
                    RoundedRectangle(cornerRadius: 12).fill(DSColor.surface)
                    Text("Charts framework not available").foregroundStyle(DSColor.textSecondary).font(.footnote)
                }
                .frame(minHeight: 140)
                #endif

                HStack(spacing: 8) {
                    Circle().fill(color.opacity(0.85)).frame(width: 8, height: 8)
                    Text(unit).foregroundStyle(DSColor.textSecondary).font(.footnote)
                    Spacer()
                    Text(labelForRange(store.range)).foregroundStyle(DSColor.textSecondary).font(.footnote)
                }
            }
        }
    }

    private func labelForRange(_ r: ProgressRange) -> String {
        switch r {
        case .day: return "Last day"
        case .week: return "Last 7 days"
        case .month: return "Last 30 days"
        case .quarter: return "Last 90 days"
        }
    }

    // MARK: - Sample Data Generation
    private func generateStepsData() -> [ProgressPoint] {
        generateSampleData(days: store.range.days, base: 8500, variance: 2500)
    }

    private func generateCaloriesData() -> [ProgressPoint] {
        generateSampleData(days: store.range.days, base: 2400, variance: 600)
    }

    private func generateSleepData() -> [ProgressPoint] {
        generateSampleData(days: store.range.days, base: 7.2, variance: 1.1)
    }

    private func generateHydrationData() -> [ProgressPoint] {
        generateSampleData(days: store.range.days, base: 1900, variance: 700)
    }

    private func generateSampleData(days: Int, base: Double, variance: Double) -> [ProgressPoint] {
        let cal = Calendar.current
        let now = Date()
        return (0..<days).map { i -> ProgressPoint in
            let d = cal.date(byAdding: .day, value: -i, to: now)!
            let v = max(0, base + Double.random(in: -variance...variance))
            return ProgressPoint(date: d, value: v)
        }.sorted { $0.date < $1.date }
    }
}
