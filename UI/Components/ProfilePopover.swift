//
//  ProfilePopover.swift
//  EverForm
//
//  Profile popover anchored to avatar button
//

import SwiftUI

struct ProfilePopover: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingDisplaySettings = false
    
    var body: some View {
        let palette = Theme.palette(colorScheme)
        
        VStack(spacing: 0) {
            // User info header
            VStack(spacing: Spacing.sm) {
                HStack {
                    Circle()
                        .fill(palette.accent.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(palette.accent)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Alex Chen")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(palette.textPrimary)
                        
                        Text("alex@example.com")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(palette.textSecondary)
                    }
                    
                    Spacer()
                }
                .padding(14)
            }
            
            Divider()
                .background(palette.stroke)
            
            // Menu items
            VStack(spacing: 0) {
                PopoverMenuRow(
                    icon: "person.circle",
                    title: "Profile"
                ) {
                    // Navigate to profile
                }
                
                PopoverMenuRow(
                    icon: "paintbrush",
                    title: "Display"
                ) {
                    showingDisplaySettings = true
                }
                
                PopoverMenuRow(
                    icon: "lock.shield",
                    title: "Security"
                ) {
                    // Navigate to security
                }
                
                PopoverMenuRow(
                    icon: "square.and.arrow.up",
                    title: "Export Data"
                ) {
                    // Export data
                }
                
                PopoverMenuRow(
                    icon: "questionmark.circle",
                    title: "Help"
                ) {
                    // Open help
                }
                
                PopoverMenuRow(
                    icon: "exclamationmark.triangle",
                    title: "Report a Bug"
                ) {
                    // Report bug
                }
            }
        }
        .frame(width: 280)
        .background(palette.surfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: Radius.card))
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.4 : 0.15), radius: 16, x: 0, y: 8)
        .sheet(isPresented: $showingDisplaySettings) {
            DisplaySettingsSheet()
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Supporting Components

private struct PopoverMenuRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let palette = Theme.palette(colorScheme)
        
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: Spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(palette.textSecondary)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(palette.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private struct DisplaySettingsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let palette = Theme.palette(colorScheme)
        
        NavigationView {
            VStack(spacing: Spacing.lg) {
                VStack(spacing: Spacing.sm) {
                    ForEach(EFAppearance.allCases, id: \.self) { mode in
                        Button(action: {
                            // Set theme mode
                            ThemeStore.shared.selection = mode
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                        }) {
                            HStack {
                                Text(mode.rawValue.capitalized)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(palette.textPrimary)

                                Spacer()

                                if ThemeStore.shared.selection == mode {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(palette.accent)
                                }
                            }
                            .padding(.horizontal, Spacing.lg)
                            .padding(.vertical, Spacing.md)
                            .background(
                                ThemeStore.shared.selection == mode ?
                                palette.accent.opacity(0.1) :
                                Color.clear
                            )
                            .clipShape(RoundedRectangle(cornerRadius: Radius.card))
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Spacer()
            }
            .padding(Spacing.lg)
            .background(palette.background)
            .navigationTitle("Display")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(palette.accent)
                }
            }
        }
    }
}

#Preview {
    ProfilePopover()
        .padding()
        .background(Theme.palette(.light).background)
}
