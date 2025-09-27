//
//  LookMaxingView.swift
//  EverForm
//
//  Look Maxing screen with photo picker, goal field, and mock AI analysis
//

import SwiftUI
import PhotosUI
import UIKit

// MARK: - Local theme + nav bar helpers (file-scoped)
fileprivate enum AppThemeUIV2 {
    static let canvas: Color = DSColor.canvas
    static let ctaNutrition: Color = DSColor.accentNutrition
    static let ctaPain: Color = EFColor.painAccent
    static let accentGreen: Color = Color.green
}

// MARK: - Look Maxing View (UI-only rebuild to match Scan Food)
struct LookMaxingView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var goalText: String = ""
    @State private var howItWorksExpanded: Bool = true
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                // Header like Scan Food (big title + subtitle)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Look Maxing")
                        .font(.system(size: 34, weight: .bold, design: .default))
                        .foregroundStyle(DSColor.textPrimary)
                        .accessibilityAddTraits(.isHeader)

                    Text("Upload a photo and tell us your goal")
                        .font(.body)
                        .foregroundStyle(DSColor.textSecondary)
                }
                .padding(.top, 4)
                .padding(.bottom, 4)

                // Card: Photo
                Card {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Photo")
                            .font(.headline)
                        PhotosPicker(selection: $selectedItem, matching: .images, preferredItemEncoding: .automatic) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(AppThemeUIV2.canvas)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .stroke(Color.black.opacity(0.06), lineWidth: 1)
                                    )
                                    .frame(height: 180)

                                if let uiImage = selectedImage {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 180)
                                        .clipped()
                                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                                } else {
                                    VStack(spacing: 10) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 28, weight: .semibold))
                                            .foregroundStyle(DSColor.textSecondary)
                                        Text("Tap to select photo")
                                            .foregroundStyle(DSColor.textSecondary)
                                    }
                                }
                            }
                        }
                        .onChange(of: selectedItem) { _, newItem in
                            guard let newItem else { return }
                            Task {
                                if let data = try? await newItem.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    selectedImage = image
                                }
                            }
                        }
                    }
                }

                // Card: Goal
                Card {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Goal")
                            .font(.headline)
                        TextField("e.g., more professional look, casual style, date night outfit…", text: $goalText, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .font(.body)
                            .foregroundStyle(Color.primary)
                            .lineLimit(3...6)
                    }
                }

                // Primary CTA (green like Scan Food)
                Button("Analyze My Look") {
                    // stub – LLM integration happens elsewhere
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(goalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedImage == nil)
                .opacity((goalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedImage == nil) ? 0.6 : 1)

                // Card: How It Works
                Card {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("How It Works")
                                .font(.headline)
                            Spacer()
                            Button {
                                withAnimation(.easeInOut) { howItWorksExpanded.toggle() }
                            } label: {
                                Image(systemName: howItWorksExpanded ? "chevron.down" : "chevron.right")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(DSColor.textSecondary)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(howItWorksExpanded ? "Collapse" : "Expand")
                        }

                        if howItWorksExpanded {
                            VStack(alignment: .leading, spacing: 14) {
                                LMStepRow(num: 1, title: "Upload your photo", text: "Take or select a photo showing your current outfit")
                                LMStepRow(num: 2, title: "Set your goal", text: "Tell us what look you're trying to achieve")
                                LMStepRow(num: 3, title: "AI Analysis", text: "Our AI analyzes your photo and goal")
                                LMStepRow(num: 4, title: "Get suggestions", text: "Receive personalized recommendations and style tips")
                            }
                            .transition(.opacity.combined(with: .scale(scale: 0.98)))
                        }
                    }
                }

                Spacer(minLength: 12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24) // for home indicator
    }
}

// MARK: - Small step row used in "How It Works"
private struct LMStepRow: View {
    let num: Int
    let title: String
    let text: String
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text("\(num)")
                .font(.headline.weight(.semibold))
                .frame(width: 24, height: 24)
                .foregroundStyle(.white)
                .background(Circle().fill(AppThemeUIV2.accentGreen))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(text).font(.subheadline).foregroundStyle(DSColor.textSecondary)
            }
        }
    }
}

// MARK: - LookMaxing local helpers
extension LookMaxingView {
    // Card used in this screen only
    fileprivate struct Card<Content: View>: View {
        let title: String?
        let subtitle: String?
        @ViewBuilder var content: Content

        init(title: String? = nil, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
            self.title = title
            self.subtitle = subtitle
            self.content = content()
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                if let title {
                    Text(title).font(.headline)
                }
                if let subtitle {
                    Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
                }
                content
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(DSColor.card)
            )
            .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 2)
        }
    }

    // Primary CTA button style used in this screen only
    fileprivate struct PrimaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(.white)
                .background(AppThemeUIV2.accentGreen)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .opacity(configuration.isPressed ? 0.85 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
        }
    }
}

// MARK: - Models (kept for compatibility)
struct LookMaxingResult {
    let overallAssessment: String
    let suggestions: [String]
    let styleTips: [String]
}

#Preview {
    LookMaxingView()
}