import SwiftUI
#if canImport(Charts)
import Charts
#endif
import UIKit


struct ProgressViewEF: View {
    @StateObject private var store = ProgressStore()
    @State private var selectedRange: ProgressRange = .day
    
    @Environment(\.horizontalSizeClass) private var hSize
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var appearance: AppearanceStore
    private var isCompact: Bool { hSize == .compact }
    private var isDark: Bool { colorScheme == .dark }

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
        ZStack {
            Color(hex: "0B0B0D").ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 16) {
                    // ----- Your existing chart sections go here (unchanged) -----
                    chartsContent()
                    // -------------------------------------------------------------
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .scrollContentBackground(.hidden) // if using List elsewhere
            // Sticky header under status bar, like Scan Food
            .safeAreaInset(edge: .top) {
                ProgressStickyHeader(
                    selectedRange: $selectedRange,
                    onChange: { newValue in
                        applyRange(newValue)
                    }
                )
                .background(Color(hex: "0B0B0D")) // same color, blends header with page (no stripe)
            }
        }
          .toolbarBackground(Color(hex: "111214"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            store.regenerate()
            startRevealAnimation()
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
        HStack(spacing: 8) {
            ForEach(segments, id: \.0) { value, label in
                Button {
                    selection = value
                } label: {
                    Text(label)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(selection == value ? Color(hex: "FFFFFF") : Color(hex: "A0A0A0"))
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .background(
                    Group {
                        if selection == value {
                            Color(hex: "2A2C30")
                        } else { 
                            Color.clear 
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .onTapGesture { selection = value }
            }
        }
        .padding(6)
        .background(Color(hex: "232529"))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color(hex: "383A3E"), lineWidth: 0.5)
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
                Text(title).font(.headline).foregroundStyle(Color(hex: "FFFFFF"))
                Spacer()
                if !isEmptyDay {
                    Text(valueFormatter(latest))
                        .font(.title3.monospacedDigit()).bold()
                        .foregroundStyle(Color(hex: "FFFFFF"))
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
                            .foregroundStyle(Color(hex: "FFFFFF"))
                        
                        Text("No data for today yet")
                            .font(.subheadline)
                            .foregroundStyle(Color(hex: "A0A0A0"))
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
                    RoundedRectangle(cornerRadius: 12).fill(Color(hex: "1A1B1E"))
                    Text("Charts framework not available")
                        .foregroundStyle(Color(hex: "A0A0A0"))
                        .font(.footnote)
                }
                .frame(minHeight: chartHeight)
                #endif
            }
        } footer: {
            if !isEmptyDay {
                HStack(spacing: 8) {
                    Circle().fill(color.opacity(0.9)).frame(width: 8, height: 8)
                    Text(series.unit).foregroundStyle(Color(hex: "A0A0A0")).font(.footnote)
                    Spacer()
                    Text(labelForRange(selectedRange)).foregroundStyle(Color(hex: "A0A0A0")).font(.footnote)
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
