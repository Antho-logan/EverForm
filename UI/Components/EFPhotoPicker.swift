//
//  EFPhotoPicker.swift
//  EverForm
//
//  Photo picker wrapper for selecting multiple images
//

import SwiftUI
import PhotosUI

struct EFPhotoPicker: View {
    @Binding var selectedImages: [UIImage]
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var isPresented = false
    
    let maxSelectionCount: Int
    let onSelection: () -> Void
    
    init(
        selectedImages: Binding<[UIImage]>,
        maxSelectionCount: Int = 6,
        onSelection: @escaping () -> Void = {}
    ) {
        self._selectedImages = selectedImages
        self.maxSelectionCount = maxSelectionCount
        self.onSelection = onSelection
    }
    
    var body: some View {
        PhotosPicker(
            selection: $selectedItems,
            maxSelectionCount: maxSelectionCount,
            matching: .images
        ) {
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(DSColor.textSecondary)
                .frame(width: 36, height: 36)
                .background(.ultraThinMaterial, in: Circle())
        }
        .onChange(of: selectedItems) { items in
            Task {
                await loadImages(from: items)
            }
        }
    }
    
    @MainActor
    private func loadImages(from items: [PhotosPickerItem]) async {
        var newImages: [UIImage] = []
        
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                newImages.append(image)
            }
        }
        
        selectedImages = newImages
        onSelection()
    }
}

// MARK: - Image Attachment Preview

struct ImageAttachmentPreview: View {
    let images: [UIImage]
    let onRemove: (Int) -> Void
    
    var body: some View {
        if !images.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 64, height: 64)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            
                            Button(action: { onRemove(index) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.white)
                                    .background(Color.black.opacity(0.6), in: Circle())
                            }
                            .offset(x: 6, y: -6)
                        }
                    }
                }
                .padding(.horizontal, 12)
            }
            .frame(height: 80)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        EFPhotoPicker(selectedImages: .constant([])) {
            print("Images selected")
        }
        
        // Preview with sample images
        ImageAttachmentPreview(images: []) { index in
            print("Remove image at index: \(index)")
        }
    }
    .padding()
    .background(DSColor.appBackground)
}
