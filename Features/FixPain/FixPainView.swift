//
//  FixPainView.swift
//  EverForm
//
//  Full-screen pain relief with body region selection
//

import SwiftUI

struct FixPainView: View {
    @State private var toastText: String?
    @State private var showingAssessment = false
    @State private var selectedArea: PainArea? = nil

    // Grid columns matching Today's Plan spacing
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(PainArea.allCases) { area in
                        FixPainCard(area: area) {
                            navigate(to: area)
                        }
                    }
                }
                .padding(.horizontal, 16) // Page padding
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .scrollContentBackground(.hidden)
            .background(DSColor.bg.ignoresSafeArea(edges: .top))
            .navigationTitle("Fix Pain")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(DSColor.bg, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            NavBlendLocal.apply()
        }
        .onDisappear {
            EFNavBarStyler.resetToDefault()
        }
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: $showingAssessment) {
            if let selectedArea = selectedArea {
                FixPainAssessmentView(area: selectedArea) { shouldShowToast in
                    if shouldShowToast {
                        toastText = "Relief plan saved"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { toastText = nil }
                    }
                    showingAssessment = false
                    // Reset selectedArea after assessment completes
                    self.selectedArea = nil
                }
            }
        }
        .overlay(alignment: .bottom) {
            if let toastText = toastText {
                Text(toastText)
                    .font(.subheadline).bold()
                    .padding(.horizontal, 14).padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.bottom, 8)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

    // Direct navigation to pain assessment without intermediate screen
    private func navigate(to area: PainArea) {
        // Add haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()

        // Set selected area and show assessment directly
        selectedArea = area
        showingAssessment = true
    }
}

#Preview {
    FixPainView()
}