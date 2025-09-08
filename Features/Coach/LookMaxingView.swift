//
//  LookMaxingView.swift
//  EverForm
//
//  Look Maxing screen with photo picker, goal field, and mock AI analysis
//

import SwiftUI
import PhotosUI

struct LookMaxingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var uiImage: UIImage?
    @State private var goalText: String = ""
    @State private var isLoading: Bool = false
    @State private var analysisResult: LookMaxingResult?
    @State private var showHowItWorks: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // MARK: - Header
                    headerSection

                    // MARK: - Photo Picker
                    photoPickerSection

                    // MARK: - Goal Input
                    goalInputSection

                    // MARK: - Analyze Button
                    analyzeButtonSection

                    // MARK: - Results
                    if let result = analysisResult {
                        resultsSection(result: result)
                    }

                    // MARK: - How It Works
                    howItWorksSection

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .background(DSColor.appBackground.ignoresSafeArea())
            .navigationTitle("Look Maxing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .onChange(of: selectedPhoto) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        uiImage = image
                    }
                }
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Get personalized look recommendations")
                .font(.title2.weight(.semibold))
                .foregroundStyle(DSColor.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Upload a photo and tell us your goal")
                .font(.subheadline)
                .foregroundStyle(DSColor.textSecondary)
                .multilineTextAlignment(.center)
        }
    }

    // MARK: - Photo Picker
    private var photoPickerSection: some View {
        VStack(spacing: 16) {
            Text("Your Photo")
                .font(.headline)
                .foregroundStyle(DSColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            PhotosPicker(
                selection: $selectedPhoto,
                matching: .images,
                photoLibrary: .shared()
            ) {
                ZStack {
                    if let image = uiImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "camera.fill")
                                .font(.title2)
                                .foregroundStyle(DSColor.textSecondary)
                            Text("Tap to select photo")
                                .font(.subheadline)
                                .foregroundStyle(DSColor.textSecondary)
                        }
                    }
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(DSColor.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(DSColor.textSecondary.opacity(0.2), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    // MARK: - Goal Input
    private var goalInputSection: some View {
        VStack(spacing: 16) {
            Text("Your Goal")
                .font(.headline)
                .foregroundStyle(DSColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField("e.g., more professional look, casual style, date night outfit...", text: $goalText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)
        }
    }

    // MARK: - Analyze Button
    private var analyzeButtonSection: some View {
        Button(action: {
            Task {
                await analyzeLook()
            }
        }) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.9)
                } else {
                    Text("Analyze My Look")
                        .font(.headline.weight(.semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.red)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(uiImage == nil || goalText.isEmpty || isLoading)
        .opacity(uiImage == nil || goalText.isEmpty || isLoading ? 0.6 : 1.0)
    }

    // MARK: - Results
    private func resultsSection(result: LookMaxingResult) -> some View {
        VStack(spacing: 20) {
            Text("AI Analysis")
                .font(.title2.weight(.semibold))
                .foregroundStyle(DSColor.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Overall Assessment
            VStack(alignment: .leading, spacing: 8) {
                Text("Overall Assessment")
                    .font(.headline)
                    .foregroundStyle(DSColor.textPrimary)
                
                Text(result.overallAssessment)
                    .font(.body)
                    .foregroundStyle(DSColor.textSecondary)
            }
            .padding(16)
            .background(DSColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Specific Suggestions
            VStack(alignment: .leading, spacing: 12) {
                Text("Specific Suggestions")
                    .font(.headline)
                    .foregroundStyle(DSColor.textPrimary)
                
                ForEach(result.suggestions, id: \.self) { suggestion in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(DSColor.brand)
                            .font(.title3)
                        
                        Text(suggestion)
                            .font(.body)
                            .foregroundStyle(DSColor.textSecondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(16)
            .background(DSColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Style Tips
            VStack(alignment: .leading, spacing: 12) {
                Text("Style Tips")
                    .font(.headline)
                    .foregroundStyle(DSColor.textPrimary)
                
                ForEach(result.styleTips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundStyle(DSColor.brand)
                            .font(.title3)
                        
                        Text(tip)
                            .font(.body)
                            .foregroundStyle(DSColor.textSecondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(16)
            .background(DSColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: - How It Works
    private var howItWorksSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                showHowItWorks.toggle()
            }) {
                HStack {
                    Text("How It Works")
                        .font(.headline)
                        .foregroundStyle(DSColor.textPrimary)
                    Spacer()
                    Image(systemName: showHowItWorks ? "chevron.up" : "chevron.down")
                        .foregroundStyle(DSColor.textSecondary)
                }
            }
            .buttonStyle(.plain)

            if showHowItWorks {
                VStack(alignment: .leading, spacing: 12) {
                    howItWorksStep(number: "1", title: "Upload your photo", description: "Take or select a photo showing your current outfit")
                    howItWorksStep(number: "2", title: "Set your goal", description: "Tell us what look you're trying to achieve")
                    howItWorksStep(number: "3", title: "AI Analysis", description: "Our AI analyzes your photo and goal")
                    howItWorksStep(number: "4", title: "Get suggestions", description: "Receive personalized recommendations and style tips")
                }
                .padding(16)
                .background(DSColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private func howItWorksStep(number: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.headline.weight(.bold))
                .foregroundStyle(DSColor.brand)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(DSColor.textPrimary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(DSColor.textSecondary)
            }
            
            Spacer()
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

// MARK: - Models
struct LookMaxingResult {
    let overallAssessment: String
    let suggestions: [String]
    let styleTips: [String]
}

#Preview {
    LookMaxingView()
}