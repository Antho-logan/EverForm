import SwiftUI
import PhotosUI
import UIKit


// MARK: - Local theme + nav bar helpers (file-scoped)
fileprivate enum AppThemeUIV2 {
    static let canvas: Color = DSColor.canvas
    static let ctaNutrition: Color = DSColor.accentNutrition
    static let ctaPain: Color = EFColor.painAccent
}



// Adapt to your real model names & JournalStore APIs.
struct SmartMealLoggerSheet: View {
  @Environment(\.colorScheme) private var colorScheme
  @EnvironmentObject var journalStore: JournalStore
  @Environment(\.dismiss) private var dismiss
  
  private var semanticColors: Theme.SemanticColors {
      Theme.semantic(colorScheme)
  }

  @State private var pickerItem: PhotosPickerItem?
  @State private var uiImage: UIImage?
  @State private var textPrompt: String = ""

  @State private var isAnalyzing = false
  @State private var estimate: MealEstimate?
  
  init() {
      // Navigation styling now handled by global EFNavBarStyler
  }

  var body: some View {
    ZStack {
      semanticColors.page
        .ignoresSafeArea()
      NavigationStack {
        ScrollView {
          VStack(spacing: 16) {

            // Photo picker
            PhotosPicker(selection: $pickerItem, matching: .images, photoLibrary: .shared()) {
              ZStack {
                RoundedRectangle(cornerRadius: 16).fill(DSColor.card)
                  .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
                  .frame(maxWidth: .infinity, minHeight: 200)
                if let image = uiImage {
                  Image(uiImage: image)
                    .resizable().scaledToFill()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                  VStack(spacing: 8) {
                    Image(systemName: "camera.viewfinder").font(.title)
                    Text("Tap to select photo").font(.subheadline).foregroundStyle(.secondary)
                  }
                }
              }
            }
            .onChange(of: pickerItem) { _, newItem in
              Task { uiImage = await loadImage(from: newItem) }
            }

            // Text prompt
            VStack(alignment: .leading, spacing: 8) {
              Text("Describe your meal").font(.headline)
              TextField("e.g., 2 eggs, avocado, buttered toast", text: $textPrompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)
            }

            // Analyze button
            let canAnalyze = !isAnalyzing && (uiImage != nil || !textPrompt.trimmingCharacters(in: .whitespaces).isEmpty)
            Button {
              Task { await analyze() }
            } label: {
              HStack {
                if isAnalyzing { ProgressView().padding(.trailing, 8) }
                Text(isAnalyzing ? "Analyzing…" : "Analyze")
              }
              .frame(maxWidth: .infinity)
              .padding(.vertical, 14)
            }
            .buttonStyle(.plain)
            .background(canAnalyze ? AppThemeUIV2.ctaNutrition : AppThemeUIV2.ctaNutrition.opacity(0.4))
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .disabled(!canAnalyze)

            // Result card
            if let e = estimate {
              VStack(alignment: .leading, spacing: 10) {
                Text("Estimated Nutrition").font(.headline)
                HStack(spacing: 16) {
                  Tag("Calories", value: "\(e.calories) kcal")
                  Tag("Protein",  value: "\(e.protein) g")
                  Tag("Carbs",    value: "\(e.carbs) g")
                  Tag("Fat",      value: "\(e.fat) g")
                }
                if !e.explanation.isEmpty {
                  Text(e.explanation)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }

                Button {
                  saveMeal(from: e)
                  dismiss()
                } label: {
                  Text("Save Meal")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.plain)
                .background(AppThemeUIV2.ctaNutrition)
                .foregroundStyle(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
              }
              .padding(16)
              .background(RoundedRectangle(cornerRadius: 16).fill(DSColor.card))
              .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
            }
          }
          .padding(16)
        }
        .navigationTitle("Smart Log (AI)")
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } }
        }
        .scrollContentBackground(.hidden)
        .background(semanticColors.page.ignoresSafeArea())
        .toolbarBackground(Color(semanticColors.page), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear { NavBlendLocal.apply() }
        .onDisappear { EFNavBarStyler.resetToDefault() }
      }
    }
  }

  // MARK: - Helpers

  private func loadImage(from item: PhotosPickerItem?) async -> UIImage? {
    guard let data = try? await item?.loadTransferable(type: Data.self) else { return nil }
    return UIImage(data: data)
  }

  private func analyze() async {
    isAnalyzing = true
    defer { isAnalyzing = false }
    // Stubbed "AI" until backend is wired:
    // Use text + whether there's an image to generate a plausible estimate.
    // Replace this with your real API later.
    try? await Task.sleep(nanoseconds: 600_000_000) // 0.6s
    let base = max(180, min(900, textPrompt.count * 20 + (uiImage == nil ? 0 : 120)))
    let protein = max(10, min(70, textPrompt.count / 2 + (uiImage == nil ? 0 : 5)))
    let fat = max(5, min(60, textPrompt.count / 3 + (uiImage == nil ? 0 : 8)))
    let carbs = max(5, min(120, textPrompt.count + (uiImage == nil ? 0 : 10)))

    estimate = .init(
      calories: base,
      protein: protein,
      carbs: carbs,
      fat: fat,
      explanation: buildExplanation()
    )
  }

  private func buildExplanation() -> String {
    var parts: [String] = []
    if !textPrompt.trimmingCharacters(in: .whitespaces).isEmpty {
      parts.append("Based on: \"\(textPrompt)\"")
    }
    if uiImage != nil { parts.append("Photo evidence used for portion sizing.") }
    return parts.joined(separator: " · ")
  }

  private func saveMeal(from e: MealEstimate) {
    // Map to your store's real API. Examples:
    // journalStore.addMeal(kind: .unspecified, date: Date(), calories: e.calories, protein: e.protein, carbs: e.carbs, fat: e.fat, note: textPrompt, image: uiImage)
    // or
    // journalStore.insert(JournalEntry.meal(...))
    journalStore.addMealFromAI(
      date: Date(),
      calories: e.calories,
      protein: e.protein,
      carbs: e.carbs,
      fat: e.fat,
      note: textPrompt,
      image: uiImage
    )
    // Ensure Overview's calories update immediately (if needed, your store should publish).
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
  }
}

// Lightweight view helpers
private struct Tag: View {
  let title: String
  let value: String
  init(_ title: String, value: String) { self.title = title; self.value = value }
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(title).font(.caption).foregroundStyle(.secondary)
      Text(value).font(.headline)
    }
    .padding(10)
    .background(RoundedRectangle(cornerRadius: 10).fill(DSColor.card.opacity(0.6)))
  }
}

struct MealEstimate {
  var calories: Int
  var protein: Int
  var carbs: Int
  var fat: Int
  var explanation: String
}