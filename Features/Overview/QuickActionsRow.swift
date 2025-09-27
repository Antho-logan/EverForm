//
//  QuickActionsRow.swift
//  EverForm
//
//  Quick actions with horizontal scrolling tiles and drag-to-reorder
//

import SwiftUI

struct QuickActionsRow: View {
    @EnvironmentObject private var router: NavigationRouter
    @State private var actions: [QuickAction] = []
    @State private var draggingID: UUID?
    @State private var isEditingReorder = false
    @AppStorage("quickActionsOrder") private var quickActionsOrderData: Data?

    var onAddWater: () -> Void

    private let dragThreshold: CGFloat = 18.0

    var body: some View {
        VStack(alignment: .leading, spacing: EFSpacing.section) {
            HStack {
                EFSectionHeader("Quick Actions")
                    .padding(.horizontal, EFSpacing.page)
                Spacer()
                Button(action: {
                    withAnimation(.snappy) {
                        isEditingReorder.toggle()
                    }
                }) {
                    Image(systemName: isEditingReorder ? "checkmark.circle.fill" : "ellipsis.circle")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(isEditingReorder ? DSColor.accentSuccess : DSColor.textSecondary)
                        .padding(.trailing, EFSpacing.page)
                }
                .buttonStyle(.plain)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(actions) { action in
                        Group {
                            if action.actionType == .addWater {
                                Button(action: {
                                    print("[QA] tapped \(action.title)")
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    onAddWater()
                                }) {
                                    QuickActionTile(
                                        title: action.title,
                                        systemName: action.icon,
                                        tint: action.color,
                                        isEditMode: isEditingReorder
                                    )
                                    .scaleEffect(draggingID == action.id ? 0.96 : 1.0)
                                    .animation(.snappy, value: draggingID == action.id)
                                }
                                .buttonStyle(.plain)
                                .accessibilityIdentifier("qa_\(action.title.lowercased().replacingOccurrences(of: " ", with: ""))")
                            } else {
                                Group {
                                    switch action.actionType {
                                case .breathwork:
                                    Button(action: {
                                        print("[QA] tapped \(action.title)")
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        router.presentModal(.breathwork)
                                    }) {
                                        QuickActionTile(
                                            title: action.title,
                                            systemName: action.icon,
                                            tint: action.color,
                                            isEditMode: isEditingReorder
                                        )
                                        .scaleEffect(draggingID == action.id ? 0.96 : 1.0)
                                        .animation(.snappy, value: draggingID == action.id)
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityIdentifier("qa_\(action.title.lowercased().replacingOccurrences(of: " ", with: ""))")
                                case .fixPain:
                                    Button(action: {
                                        print("[QA] tapped \(action.title)")
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        router.presentModal(.fixPain)
                                    }) {
                                        QuickActionTile(
                                            title: action.title,
                                            systemName: action.icon,
                                            tint: action.color,
                                            isEditMode: isEditingReorder
                                        )
                                        .scaleEffect(draggingID == action.id ? 0.96 : 1.0)
                                        .animation(.snappy, value: draggingID == action.id)
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityIdentifier("qa_\(action.title.lowercased().replacingOccurrences(of: " ", with: ""))")
                                case .lookMaxing:
                                    Button(action: {
                                        print("[QA] tapped \(action.title)")
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        router.presentModal(.lookMaxing)
                                    }) {
                                        QuickActionTile(
                                            title: action.title,
                                            systemName: action.icon,
                                            tint: action.color,
                                            isEditMode: isEditingReorder
                                        )
                                        .scaleEffect(draggingID == action.id ? 0.96 : 1.0)
                                        .animation(.snappy, value: draggingID == action.id)
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityIdentifier("qa_\(action.title.lowercased().replacingOccurrences(of: " ", with: ""))")
                                default:
                                    // This should never be reached as all cases are handled above
                                    EmptyView()
                                }
                                }
                            }
                        }
                        // Only enable drag gestures when in edit mode - prevents stealing taps
                        .gesture(
                            DragGesture(minimumDistance: isEditingReorder ? dragThreshold : 1000)
                                .onChanged { value in
                                    guard isEditingReorder else { return }
                                    if draggingID == nil {
                                        draggingID = action.id
                                        print("[QA] drag started for \(action.title)")
                                    }
                                }
                                .onEnded { _ in
                                    draggingID = nil
                                    print("[QA] drag ended")
                                }
                        )
                        // Drag source (only in edit mode)
                        .onDrag {
                            guard isEditingReorder else {
                                print("[QA] drag prevented - not in edit mode")
                                return NSItemProvider()
                            }
                            draggingID = action.id
                            return NSItemProvider(object: action.id.uuidString as NSString)
                        }
                        // Drop target (side-to-side reorder)
                        .onDrop(of: [.text], isTargeted: nil) { providers in
                            guard isEditingReorder else { return false }
                            guard let item = draggingID,
                                  let from = actions.firstIndex(where: { $0.id == item }),
                                  let to = actions.firstIndex(where: { $0.id == action.id })
                            else { return false }

                            if from != to {
                                withAnimation(.snappy) {
                                    let movedAction = actions.remove(at: from)
                                    actions.insert(movedAction, at: to)
                                    persistOrder()
                                    print("[QA] reordered \(movedAction.title) from \(from) to \(to)")
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                }
                            }
                            draggingID = nil
                            return true
                        }
                    }
                }
            }
            .padding(.horizontal, EFSpacing.page)
            .padding(.top, EFSpacing.section)
            .onDrop(of: [.text], isTargeted: nil) { _ in
                draggingID = nil
                return false
            }
            .onAppear {
                seedActionsAndApplySavedOrder()
            }
        }
    }

    // MARK: - Tile Component
    private struct QuickActionTile: View {
        let title: String
        let systemName: String
        let tint: Color
        let isEditMode: Bool

        var body: some View {
            EFCard {
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(tint.opacity(0.12))
                            .frame(width: 32, height: 32)
                        Image(systemName: systemName)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(tint)

                        // Show reorder handle in edit mode
                        if isEditMode {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image(systemName: "line.3.horizontal")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundStyle(DSColor.textSecondary)
                                        .padding(.bottom, 2)
                                        .padding(.trailing, 2)
                                }
                            }
                        }
                    }
                    Text(title)
                        .font(.footnote)
                        .foregroundStyle(DSColor.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                }
                .padding(10)
                .frame(width: 120, height: 86)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isEditMode ? DSColor.accentSuccess.opacity(0.5) : Color.clear, lineWidth: 2)
                        .allowsHitTesting(false) // Decorative overlay shouldn't block taps
                )
            }
        }
    }

    
    // MARK: - Persistence
    private func persistOrder() {
        let ids = actions.map(\.id)
        quickActionsOrderData = try? JSONEncoder().encode(ids)
    }

    private func seedActionsAndApplySavedOrder() {
        if actions.isEmpty {
            actions = [
                QuickAction(
                    id: UUID(),
                    title: "Add Water",
                    icon: "drop.fill",
                    colorName: "accentRecovery",
                    actionType: .addWater
                ),
                QuickAction(
                    id: UUID(),
                    title: "Breathwork",
                    icon: "wind",
                    colorName: "accentSuccess",
                    actionType: .breathwork
                ),
                QuickAction(
                    id: UUID(),
                    title: "Fix Pain",
                    icon: "cross.case.fill",
                    colorName: "accentDanger",
                    actionType: .fixPain
                ),
                QuickAction(
                    id: UUID(),
                    title: "Look Maxing",
                    icon: "person.fill.viewfinder",
                    colorName: "accentMobility",
                    actionType: .lookMaxing
                ),
            ]
        }

        if let data = quickActionsOrderData,
           let saved = try? JSONDecoder().decode([UUID].self, from: data) {
            let map = Dictionary(uniqueKeysWithValues: actions.enumerated().map { ($1.id, $0) })
            actions.sort { (lhs, rhs) in
                (saved.firstIndex(of: lhs.id) ?? map[lhs.id]!) < (saved.firstIndex(of: rhs.id) ?? map[rhs.id]!)
            }
        }
    }
}