import SwiftUI
#if canImport(Charts)
import Charts
#endif
import UIKit

// MARK: - Local NavBar helper (file-scoped; no project settings needed)
private func ef_applySolidNavBar(background: Color) {
    let ui = UIColor(background)
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = ui
    appearance.shadowColor = .clear
    appearance.shadowImage = UIImage() // extra guard

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
}

struct ProgressViewEF: View {
    @StateObject private var store = ProgressStore()

    @Environment(\.horizontalSizeClass) private var hSize
    @Environment(\.colorScheme) private var colorScheme
    private var isCompact: Bool { hSize == .compact }

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
        NavigationStack {
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section(header: ProgressHeader(store: store, isCompact: isCompact)) {
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
                            .animation(.snappy(duration: 0.45, extraBounce: 0.04), value: store.range)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 32)
                        }
                    }
                }
            }
            .background(DSColor.appBackground.ignoresSafeArea())
            .ignoresSafeArea(edges: .top)
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(DSColor.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(colorScheme == .dark ? .dark : .light, for: .navigationBar)
            .onAppear {
                ef_applySolidNavBar(background: DSColor.appBackground)
                store.regenerate()
                startRevealAnimation()
            }
            .onDisappear {
                // No need to restore - helper applies appearance globally
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

// MARK: - Progress Header

struct ProgressHeader: View {
    @ObservedObject var store: ProgressStore
    let isCompact: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
        .padding(.vertical, 16)
        .background(DSColor.appBackground)
    }
}

    // MARK: - Cards

    @ViewBuilder
    private func metricCard(title: String, color: Color, series: EFMetricSeries, valueFormatter: (Double)->String) -> some View {
        let latest = series.points.last?.value ?? 0
        
        // Check if Day view has no meaningful data
        let isEmptyDay = store.range == .day && series.points.count <= 2 && series.points.allSatisfy { $0.value == 0 }

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
                    Text(labelForRange(store.range)).foregroundStyle(DSColor.textSecondary).font(.footnote)
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
