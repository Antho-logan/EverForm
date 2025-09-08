//
//  LookMaxingView.swift
//  EverForm
//
//  Look Maxing screen with photo picker, goal field, and mock AI analysis
//

import SwiftUI
import PhotosUI
import UIKit

// MARK: - Hide Apple nav stripe/shadow (keeps our in-app header)
fileprivate enum EFNavAppearance {
    static func hideStripe() {
        let ap = UINavigationBarAppearance()
        ap.configureWithOpaqueBackground()
        ap.backgroundColor = .clear  // let our canvas show through
        ap.shadowColor = .clear      // remove the hairline/stripe
        ap.titleTextAttributes = [.foregroundColor: UIColor.clear]
        ap.largeTitleTextAttributes = [.foregroundColor: UIColor.clear]
        let nav = UINavigationBar.appearance()
        nav.standardAppearance   = ap
        nav.scrollEdgeAppearance = ap
        nav.compactAppearance    = ap
    }
}

// MARK: - LookMaxingView (drop-in replacement of your existing struct)
struct LookMaxingView: View {
    
    // ---- Map these to your existing state/view-model if names differ ----
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var uiImage: UIImage?
    @State private var goalText: String = ""
    @State private var isLoading: Bool = false
    @State private var analysisResult: LookMaxingResult?
    // --------------------------------------------------------------------

    var body: some View {
        // Use app canvas and hide default nav chrome
        let canvas = DSColor.appBackground
        let cardBG = DSColor.card

        ZStack {
            canvas.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // In-app large header (matches Scan Food style)
                    Text("Look Maxing")
                        .font(.system(size: 34, weight: .bold))   // same large title weight/size as Scan Food
                        .kerning(-0.5)
                        .padding(.top, 6)

                    // Optional subtitle (mirrors Scan Food's descriptive lead)
                    Text("Upload a photo and tell us your goal")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    // --- Photo card ---
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Photo")
                            .font(.headline)

                        PhotosPicker(
                            selection: $selectedPhoto,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(cardBG)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(Color.black.opacity(0.06), lineWidth: 1)
                                    )
                                    .frame(maxWidth: .infinity, minHeight: 180)

                                if let image = uiImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, minHeight: 180)
                                        .clipped()
                                        .cornerRadius(16)
                                } else {
                                    VStack(spacing: 8) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 28, weight: .semibold))
                                            .foregroundStyle(.secondary)
                                        Text("Tap to select photo")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(16)
                    .background(cardBG, in: .rect(cornerRadius: 20, style: .continuous))

                    // --- Goal card ---
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Goal")
                            .font(.headline)

                        TextField("e.g., more professional look, casual style, date night outfit…", text: $goalText, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .font(.body)
                            .lineLimit(3...6)
                            .submitLabel(.done)

                        Button {
                            // hook existing analyze action here
                            Task {
                                await analyzeLook()
                            }
                        } label: {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.9)
                                } else {
                                    Text("Analyze My Look")
                                        .font(.headline)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(hex: 0xE05252)) // Use the existing red color from theme
                        .disabled(uiImage == nil || goalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
                        .opacity((uiImage == nil || goalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading) ? 0.6 : 1)
                    }
                    .padding(16)
                    .background(cardBG, in: .rect(cornerRadius: 20, style: .continuous))

                    // --- Results (if available) ---
                    if let result = analysisResult {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("AI Analysis")
                                .font(.headline)

                            // Overall Assessment
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Overall Assessment")
                                    .font(.subheadline.weight(.semibold))
                                
                                Text(result.overallAssessment)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }

                            // Specific Suggestions
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Specific Suggestions")
                                    .font(.subheadline.weight(.semibold))
                                
                                ForEach(result.suggestions, id: \.self) { suggestion in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.green)
                                            .font(.caption)
                                        
                                        Text(suggestion)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }

                            // Style Tips
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Style Tips")
                                    .font(.subheadline.weight(.semibold))
                                
                                ForEach(result.styleTips, id: \.self) { tip in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "lightbulb.fill")
                                            .foregroundStyle(.green)
                                            .font(.caption)
                                        
                                        Text(tip)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(cardBG, in: .rect(cornerRadius: 20, style: .continuous))
                    }

                    // --- How it works (same feel as the 3rd screenshot) ---
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How It Works")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 14) {
                            LookStepRow(step: 1, title: "Upload your photo",
                                        desc: "Take or select a photo showing your current outfit")
                            LookStepRow(step: 2, title: "Set your goal",
                                        desc: "Tell us what look you're trying to achieve")
                            LookStepRow(step: 3, title: "AI Analysis",
                                        desc: "Our AI analyzes your photo and goal")
                            LookStepRow(step: 4, title: "Get suggestions",
                                        desc: "Receive personalized recommendations and style tips")
                        }
                        .padding(.top, 6)
                    }
                    .padding(16)
                    .background(cardBG, in: .rect(cornerRadius: 20, style: .continuous))

                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            EFNavAppearance.hideStripe()        // remove the hairline
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)   // hide Apple nav UI ("Done", default title bar)
        .scrollIndicators(.hidden)
        .background(canvas)                      // ensure bottom bar matches page color
        .onChange(of: selectedPhoto) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    uiImage = image
                }
            }
        }
    }

    // MARK: - Analysis Logic
    private func analyzeLook() async {
        guard uiImage != nil, !goalText.isEmpty else { return }

        isLoading = true
        
        // Simulate API call delay
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Mock AI analysis result
        let mockResult = LookMaxingResult(
            overallAssessment: "Based on your photo and goal, I can see you're going for a professional yet approachable look. Your current outfit has good basics but could use some refinement.",
            suggestions: [
                "Consider adding a structured blazer to elevate your professional appearance",
                "Swap the casual t-shirt for a collared shirt or polo in a complementary color",
                "Add a watch or subtle accessories to complete the professional look",
                "Ensure your shoes are clean and polished - footwear makes a big impact"
            ],
            styleTips: [
                "Fit is everything - ensure clothes are tailored to your body shape",
                "Stick to a cohesive color palette for a more put-together appearance",
                "Quality fabrics make a significant difference in perceived professionalism",
                "Less is more when it comes to accessories in professional settings"
            ]
        )
        
        analysisResult = mockResult
        isLoading = false
    }
}

// MARK: - Reusable numbered row (1–4) used in "How It Works"
fileprivate struct LookStepRow: View {
    let step: Int
    let title: String
    let desc: String
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(step)")
                .font(.headline)
                .foregroundStyle(.green)                     // subtle accent like examples
                .frame(width: 24, height: 24)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline).fontWeight(.semibold)
                Text(desc).font(.footnote).foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Models
struct LookMaxingResult {
    let overallAssessment: String
    let suggestions: [String]
    let styleTips: [String]
}

#Preview {
    LookMaxingView()
}