//
//  LookMaxingView.swift
//  EverForm
//
//  Look Maxing screen with photo picker, goal field, and mock AI analysis
//

import SwiftUI
import PhotosUI

// MARK: - Local theme conveniences (uses app tokens; falls back if needed)
private extension Color {
    static var efCanvas: Color { DSColor.appBackground }        // matches Scan Food background
    static var efCard: Color { DSColor.card }                   // matches card fill
    static var efCardStroke: Color { Color.black.opacity(0.06) } // subtle stroke like Scan Food
    static var efShadow: Color { Color.black.opacity(0.07) }     // soft shadow
    static var efTitle: Color { DSColor.textPrimary }            // big title color
    static var efSubtitle: Color { DSColor.textSecondary }       // subtitle gray
    static var efAccentGreen: Color { Color.green }              // same green used on Scan Food CTA
}

// MARK: - Local Card container that matches Scan Food cards
private struct LMCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        content
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.efCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.efCardStroke, lineWidth: 1)
                    )
                    .shadow(color: Color.efShadow, radius: 10, x: 0, y: 4)
            )
    }
}

// MARK: - Local primary button style that mirrors Scan Food "Generate Mock Result"
private struct LMPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.efAccentGreen.opacity(configuration.isPressed ? 0.85 : 1))
            )
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}

// MARK: - Look Maxing View (UI-only rebuild to match Scan Food)
struct LookMaxingView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var goalText: String = ""
    @State private var howItWorksExpanded: Bool = true

    var body: some View {
        ZStack {
            // Canvas background identical to Scan Food
            Color.efCanvas.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {

                    // Header like Scan Food (big title + subtitle)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Look Maxing")
                            .font(.system(size: 34, weight: .bold, design: .default))
                            .foregroundStyle(Color.efTitle)
                            .accessibilityAddTraits(.isHeader)

                        Text("Upload a photo and tell us your goal")
                            .font(.body)
                            .foregroundStyle(Color.efSubtitle)
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 4)

                    // Card: Photo
                    LMCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Photo")
                                .font(.headline)
                            PhotosPicker(selection: $selectedItem, matching: .images, preferredItemEncoding: .automatic) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color.efCanvas)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .stroke(Color.efCardStroke, lineWidth: 1)
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
                                                .foregroundStyle(Color.efSubtitle)
                                            Text("Tap to select photo")
                                                .foregroundStyle(Color.efSubtitle)
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
                    LMCard {
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
                    .buttonStyle(LMPrimaryButtonStyle())
                    .disabled(goalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedImage == nil)
                    .opacity((goalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedImage == nil) ? 0.6 : 1)

                    // Card: How It Works
                    LMCard {
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
                                        .foregroundStyle(Color.efSubtitle)
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
                .padding(.horizontal, 20)
                .padding(.bottom, 24) // for home indicator
            }
        }
        // Hide default Apple nav UI + stripe/divider
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarHidden(true)
        .onAppear {
            // Defensive: if any previous screen forced a bar, hide it here too.
            UINavigationBar.appearance().isHidden = true
        }
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
                .background(Circle().fill(Color.efAccentGreen))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(text).font(.subheadline).foregroundStyle(Color.efSubtitle)
            }
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