//
//  EFModalSheetScaffold.swift
//  EverForm
//
//  Reusable bottom sheet scaffold matching Fix Pain styling
//

import SwiftUI

struct EFModalSheetScaffold<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        // Outer sand background to match the app
        ZStack {
            EFTheme.appBackground.ignoresSafeArea()

            // Sheet body with rounded top, same as Fix Pain
            VStack(spacing: 0) {
                // Header (no grabber, no divider)
                Text(title)
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .foregroundStyle(DSColor.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 24)

                // Scrollable body
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        content
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32) // home-indicator space
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(EFTheme.sheetBackground)
                    .ignoresSafeArea(edges: .bottom)
            )
            .padding(.top, 12)   // match Fix Pain spacing to status bar
            .padding(.horizontal, 0)
        }
    }
}
