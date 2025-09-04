//
//  EFLevelMeterView.swift
//  EverForm
//
//  Audio level meter visualization for voice recording
//

import SwiftUI

struct EFLevelMeterView: View {
    let levels: [Float]
    @Environment(\.colorScheme) private var colorScheme
    
    private let barCount = 32
    private let barSpacing: CGFloat = 2
    private let minBarHeight: CGFloat = 3
    private let maxBarHeight: CGFloat = 18
    
    var body: some View {
        HStack(spacing: barSpacing) {
            ForEach(0..<barCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 1.5, style: .continuous)
                    .fill(barColor)
                    .frame(width: 2, height: barHeight(for: index))
                    .animation(.easeInOut(duration: 0.1), value: barHeight(for: index))
            }
        }
        .frame(height: maxBarHeight)
    }
    
    private var barColor: Color {
        colorScheme == .light 
            ? DSColor.textSecondary.opacity(0.7)
            : DSColor.textSecondary.opacity(0.9)
    }
    
    private func barHeight(for index: Int) -> CGFloat {
        let levelIndex = index * levels.count / barCount
        let level = levelIndex < levels.count ? levels[levelIndex] : 0.0
        let normalizedLevel = CGFloat(max(0, min(1, level)))
        return minBarHeight + (maxBarHeight - minBarHeight) * normalizedLevel
    }
}

#Preview {
    VStack(spacing: 20) {
        // Static levels for preview
        EFLevelMeterView(levels: [0.2, 0.5, 0.8, 0.3, 0.7, 0.1, 0.9, 0.4, 0.6, 0.2])
            .padding()
            .background(DSColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        
        // Animated levels for preview
        EFLevelMeterView(levels: Array(repeating: 0.0, count: 20))
            .padding()
            .background(DSColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
    .padding()
    .background(DSColor.appBackground)
}
