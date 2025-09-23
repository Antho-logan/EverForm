import SwiftUI

struct ScanView: View {
    @EnvironmentObject private var appearance: AppearanceStore
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.efTextTheme) private var textTheme
    
    private var isDark: Bool { colorScheme == .dark }
    
    var body: some View {
        ZStack {
            DSColor.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                Text("Scan Food")
                    .font(.system(.largeTitle, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .background(DSColor.bg)
                    .zIndex(1)

                ScrollView {
                    VStack(spacing: EFSpacing.section) {
                        SegmentedTabs()

                        EFCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Calorie & Macros").font(.headline).foregroundStyle(DSColor.labelPrimary)
                                Text("Scan barcode or nutrition label for accurate calorie and macro information")
                                    .font(.subheadline).foregroundStyle(DSColor.labelSecondary)
                                Button("Generate Mock Result") {}
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(DSColor.accentPrimary)
                                    .foregroundStyle(DSColor.inverse)
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                Button("Import Photo") {}
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(EFColor.stroke.opacity(0.12), lineWidth: 1))
                                    .foregroundStyle(DSColor.labelPrimary)
                                    .background(Color.clear)
                            }
                        }

                        EFCard {
                            VStack(spacing: 12) {
                                Image(systemName: "viewfinder").font(.largeTitle).foregroundStyle(DSColor.labelSecondary)
                                Text("Nothing scanned yet").font(.headline).foregroundStyle(DSColor.labelPrimary)
                                Text("Try a mock result to see how it works").font(.subheadline).foregroundStyle(DSColor.labelSecondary)
                            }.frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, EFSpacing.page)
                    .padding(.top, 8)
                }
                .scrollContentBackground(.hidden)
                .toolbar(.hidden, for: .navigationBar)
                .toolbarBackground(.hidden, for: .navigationBar)
            }
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
                TabChip(title: items[i], isSelected: i == idx) {
                    idx = i
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private struct TabChip: View {
        let title: String
        let isSelected: Bool
        let action: () -> Void

        var body: some View {
            Text(title)
                .font(.subheadline.weight(isSelected ? .bold : .regular))
                .foregroundStyle(isSelected ? DSColor.inverse : DSColor.labelSecondary)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    Capsule()
                        .fill(isSelected ? DSColor.accentPrimary : Color.clear)
                        .overlay(
                            Capsule()
                                .stroke(isSelected ? Color.clear : EFColor.stroke.opacity(0.12), lineWidth: 1)
                        )
                )
                .onTapGesture { action() }
        }
    }
}
