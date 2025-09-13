import SwiftUI

struct ScanView: View {
    @EnvironmentObject private var appearance: AppearanceStore
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    SegmentedTabs()
                    
                    EFCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Calorie & Macros").font(.headline).foregroundStyle(AppTheme.textPrimary(for: colorScheme, appearance.appAppearance))
                            Text("Scan barcode or nutrition label for accurate calorie and macro information")
                                .font(.subheadline).foregroundStyle(AppTheme.textSecondary(for: colorScheme, appearance.appAppearance))
                            Button("Generate Mock Result") {}
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(DSColor.accentNutrition)
                                .foregroundStyle(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            Button("Import Photo") {}
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(DSColor.accentNutrition))
                                .foregroundStyle(DSColor.accentNutrition)
                        }
                    }
                    
                    EFCard {
                        VStack(spacing: 12) {
                            Image(systemName: "viewfinder").font(.largeTitle).foregroundStyle(AppTheme.textSecondary(for: colorScheme, appearance.appAppearance))
                            Text("Nothing scanned yet").font(.headline).foregroundStyle(AppTheme.textPrimary(for: colorScheme, appearance.appAppearance))
                            Text("Try a mock result to see how it works").font(.subheadline).foregroundStyle(AppTheme.textSecondary(for: colorScheme, appearance.appAppearance))
                        }.frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .scrollContentBackground(.hidden)
            .background(DSColor.appBackground.ignoresSafeArea())
            .toolbarBackground(DSColor.appBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle("Scan Food")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

private struct SegmentedTabs: View {
    @State private var idx = 0
    @EnvironmentObject private var appearance: AppearanceStore
    @Environment(\.colorScheme) private var colorScheme
    let items = ["Calorie","Ingredients","Plate AI"]
    var body: some View {
        HStack(spacing: 8) {
            ForEach(items.indices, id: \.self) { i in
                Text(items[i])
                    .font(.subheadline.weight(i == idx ? .bold : .regular))
                    .foregroundStyle(i == idx ? DSColor.textPrimary : DSColor.textSecondary)
                    .padding(.vertical, 8).padding(.horizontal, 14)
                    .background(DSColor.elevated.opacity(i == idx ? 1 : 0.7))
                    .clipShape(Capsule())
                    .onTapGesture { idx = i }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
