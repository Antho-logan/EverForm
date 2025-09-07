import SwiftUI
#if canImport(Charts)
import Charts
#endif
import UIKit

// MARK: - Local nav bar styling helper (file-scoped; no project changes)
fileprivate enum ProgressNavBarStyler {
    static func apply(background uiColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = uiColor
        appearance.shadowColor = .clear        // ← removes the faint separator/stripe
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

        let nav = UINavigationBar.appearance()
        nav.standardAppearance = appearance
        nav.scrollEdgeAppearance = appearance
        nav.compactAppearance = appearance
    }

    static func resetToDefault() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = .clear
        let nav = UINavigationBar.appearance()
        nav.standardAppearance = appearance
        nav.scrollEdgeAppearance = appearance
        nav.compactAppearance = appearance
    }
}

struct ProgressViewEF: View {
    @StateObject private var store = ProgressStore()
    @State private var selectedRange: ProgressRange = .day
    
    @Environment(\.horizontalSizeClass) private var hSize
    @Environment(\.colorScheme) private var colorScheme
    private var isCompact: Bool { hSize == .compact }

    // If you already have a theme token, use that exact token here for both SwiftUI & UIKit.
    private var pageBackground: Color {
        DSColor.appBackground // Using existing app theme token
    }

    // Drives chart rebuild + reveal animation
    @State private var chartIdentity: Int = 0
    @State private var reveal: CGFloat = 1.0
    
    // Layout
    private var grid: [GridItem] {
        isCompact ? [GridItem(.flexible())]
                  : [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    }
    private var chartHeight: CGFloat { isCompact ? 220 : 190 }

    var body: some View {
        let bg = pageBackground
        let uiBG = UIColor(bg)

        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 16) {
                // ----- Your existing chart sections go here (unchanged) -----
                chartsContent()
                // -------------------------------------------------------------
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(bg.ignoresSafeArea())
        // Sticky header under status bar, like Scan Food
        .safeAreaInset(edge: .top) {
            ProgressStickyHeader(
                selectedRange: $selectedRange,
                onChange: { newValue in
                    applyRange(newValue)
                }
            )
            .background(bg) // same color, blends header with page (no stripe)
        }
        .onAppear {
            ProgressNavBarStyler.apply(background: uiBG) // removes faint line
            store.regenerate()
            startRevealAnimation()
        }
        .onDisappear {
            ProgressNavBarStyler.resetToDefault()
        }
    }

    // Keep all your existing logic; this function just hosts the old chart list UI.
    @ViewBuilder
    private func chartsContent() -> some View {
        VStack(spacing: 16) {
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
            .animation(.snappy(duration: 0.45, extraBounce: 0.04), value: selectedRange)
            .padding(.horizontal, 4)
            .padding(.bottom, 32)
        }
    }

    // Bridge to your existing range handling if needed.
    private func applyRange(_ value: ProgressRange) {
        store.range = value
        withAnimation(.snappy(duration: 0.45, extraBounce: 0.04)) {
            chartIdentity &+= 1
        }
        store.regenerate()
        startRevealAnimation()
    }

// MARK: - Sticky header (title + segmented control)
fileprivate struct ProgressStickyHeader: View {
    @Binding var selectedRange: ProgressRange
    var onChange: (ProgressRange) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progress")
                .font(.system(size: 34, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, alignment: .leading)

            // Segmented control (Day / Week / Month)
            SegmentedPicker(
                selection: $selectedRange,
                segments: [
                    (.day,   "Day"),
                    (.week,  "Week"),
                    (.month, "Month")
                ]
            )
            .onChange(of: selectedRange) { _, newValue in
                onChange(newValue)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 10)
    }
}

// MARK: - Minimal capsule-style segmented picker
fileprivate struct SegmentedPicker<Value: Hashable>: View {
    @Binding var selection: Value
    let segments: [(Value, String)]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments, id: \.0) { value, label in
                Button {
                    selection = value
                } label: {
                    Text(label)
                        .font(.system(size: 15, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
                .background(
                    Group {
                        if selection == value {
                            // filled (selected)
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial) // or your app's selected fill
                        } else {
                            Color.clear
                        }
                    }
                )
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.thinMaterial) // or your app's control background token
        )
    }
}

    // MARK: - Cards

    @ViewBuilder
    private func metricCard(title: String, color: Color, series: EFMetricSeries, valueFormatter: (Double)->String) -> some View {
        let latest = series.points.last?.value ?? 0
        
        // Check if Day view has no meaningful data
        let isEmptyDay = selectedRange == .day && series.points.count <= 2 && series.points.allSatisfy { $0.value == 0 }

        ChartCard {
            HStack {
                Text(title).font(.headline).foregroundStyle(DSColor.textPrimary)
                Spacer()
                if !isEmptyDay {
                    Text(valueFormatter(latest))
                        .font(.title3.monospacedDigit()).bold()
                        .foregroundStyle(DSColor.textPrimary)
                        .contentTransition(.numericText())
                }
            }
        } chart: {
            if isEmptyDay {
                // Empty state for Day view
                VStack(spacing: 16) {
                    Image(systemName: iconForTitle(title))
                        .font(.system(size: 48))
                        .foregroundStyle(color.opacity(0.6))
                    
                    VStack(spacing: 8) {
                        Text("Today")
                            .font(.headline)
                            .foregroundStyle(DSColor.textPrimary)
                        
                        Text("No data for today yet")
                            .font(.subheadline)
                            .foregroundStyle(DSColor.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button("Log now") {
                        // Stub action - would route to relevant logging
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                    }
                    .buttonStyle(.bordered)
                    .tint(color)
                }
                .frame(minHeight: chartHeight)
            } else {
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
            }
        } footer: {
            if !isEmptyDay {
                HStack(spacing: 8) {
                    Circle().fill(color.opacity(0.9)).frame(width: 8, height: 8)
                    Text(series.unit).foregroundStyle(DSColor.textSecondary).font(.footnote)
                    Spacer()
                    Text(labelForRange(selectedRange)).foregroundStyle(DSColor.textSecondary).font(.footnote)
                }
            }
        }
    }
    
    private func iconForTitle(_ title: String) -> String {
        switch title.lowercased() {
        case "steps": return "figure.walk"
        case "calories": return "fork.knife"
        case "sleep": return "bed.double.fill"
        case "hydration": return "drop.fill"
        default: return "chart.line.uptrend.xyaxis"
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
