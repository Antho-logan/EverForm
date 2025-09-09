//
//  SelectableChip.swift
//  EverForm
//
//  Reusable selectable chip with theme styling
//

import SwiftUI

struct SelectableChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.callout.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isSelected ? EFColor.Pill.selectedBackground : EFColor.Pill.background)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(isSelected ? EFColor.Pill.selectedStroke : EFColor.Pill.stroke, lineWidth: 1)
                        )
                        .shadow(color: EFColor.Pill.shadow.opacity(isSelected ? 0.15 : 0.05), radius: isSelected ? 6 : 2, y: isSelected ? 3 : 1)
                )
                .foregroundStyle(isSelected ? EFColor.Pill.selectedText : EFColor.Pill.text)
                .animation(.spring(response: 0.25, dampingFraction: 0.9), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}