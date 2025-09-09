//
//  NeckPainIcon.swift
//  EverForm
//
//  Custom neck pain icon matching the style and weight of other icons
//

import SwiftUI

struct NeckPainIcon: View {
    var body: some View {
        ZStack {
            // Head and neck/shoulders simplified
            Path { path in
                // Head (circle)
                path.addArc(center: CGPoint(x: 14, y: 8), radius: 6, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: false)
                
                // Neck/shoulder curve
                path.move(to: CGPoint(x: 14, y: 14))
                path.addQuadCurve(to: CGPoint(x: 8, y: 22), control: CGPoint(x: 10.5, y: 17.5))
                path.addLine(to: CGPoint(x: 20, y: 22))
                path.addQuadCurve(to: CGPoint(x: 14, y: 14), control: CGPoint(x: 17.5, y: 17.5))
            }
            .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
            
            // Pain indicator near the neck
            Path { path in
                path.move(to: CGPoint(x: 18, y: 14))
                path.addLine(to: CGPoint(x: 22, y: 11))
                path.move(to: CGPoint(x: 18, y: 16))
                path.addLine(to: CGPoint(x: 22, y: 13))
            }
            .stroke(style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
        }
        .foregroundStyle(EFColor.painAccent)
    }
}