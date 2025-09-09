//
//  LogMealView.swift
//  EverForm
//
//  Sheet UI for logging meals with nutrition tracking
//

import SwiftUI

// MARK: - Design System Shims (use existing components if available)
#if canImport(EFDesignSystem)
import EFDesignSystem
#endif

extension Color {
    static var efCanvas: Color { DSColor.appBackground }
    static var efCardFill: Color { DSColor.card }
    static var efCardStroke: Color { Color.black.opacity(0.06) }
    static var efShadow: Color { Color.black.opacity(0.07) }
    static var efAccentRed: Color { Color(hex: 0xE05252) }
    static var efAccentGreen: Color { Color.green }
}

struct LMCard<Content: View>: View {
    let content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    var body: some View {
        content()
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.efCardFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.efCardStroke, lineWidth: 1)
                    )
                    .shadow(color: .efShadow, radius: 10, x: 0, y: 4)
            )
    }
}

struct LMPrimaryButtonStyle: ButtonStyle {
    enum Tint { case red, green }
    var tint: Tint = .red
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill((tint == .red ? Color.efAccentRed : Color.efAccentGreen)
                        .opacity(configuration.isPressed ? 0.86 : 1))
            )
            .foregroundStyle(.white)
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}

// MARK: - Main View
struct LogMealView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var type: EFMealType = .dinner
    @State private var when: Date = Date()
    @State private var items: [EFFoodItem] = [EFFoodItem()]
    @State private var notes: String = ""
    
    private var totals: (kcal: Double, p: Double, c: Double, f: Double) {
        let kcal = items.reduce(0) { $0 + max(0, $1.kcal) }
        let p    = items.reduce(0) { $0 + max(0, $1.protein) }
        let c    = items.reduce(0) { $0 + max(0, $1.carbs) }
        let f    = items.reduce(0) { $0 + max(0, $1.fat) }
        return (kcal, p, c, f)
    }
    private var canSave: Bool {
        items.contains { !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && $0.kcal > 0 }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header
                LMCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Log Meal")
                            .font(.title.bold())
                        Text("Add foods and macros. You can refine later.")
                            .foregroundStyle(.secondary)
                        Picker("Meal", selection: $type) {
                            ForEach(EFMealType.allCases) { t in
                                Text("\(t.emoji) \(t.title)").tag(t)
                            }
                        }
                        .pickerStyle(.segmented)
                        DatePicker("Time", selection: $when, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                    }
                }
                
                // Items
                LMCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Foods")
                            .font(.headline)
                        ForEach(items.indices, id: \.self) { i in
                            VStack(spacing: 8) {
                                TextField("Name (e.g., 2 eggs)", text: $items[i].name)
                                    .textInputAutocapitalization(.words)
                                    .autocorrectionDisabled()
                                
                                HStack(spacing: 12) {
                                    numberField(title: "kcal", value: $items[i].kcal)
                                    numberField(title: "P", value: $items[i].protein)
                                    numberField(title: "C", value: $items[i].carbs)
                                    numberField(title: "F", value: $items[i].fat)
                                }
                            }
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.efCanvas))
                            
                            if i != items.indices.last {
                                Divider().opacity(0.2)
                            }
                        }
                        
                        Button {
                            items.append(EFFoodItem())
                        } label: {
                            Label("Add another food", systemImage: "plus.circle.fill")
                                .labelStyle(.titleAndIcon)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                    }
                }
                
                // Totals
                LMCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Totals")
                            .font(.headline)
                        HStack {
                            stat("kcal", totals.kcal)
                            Spacer()
                            stat("P", totals.p)
                            Spacer()
                            stat("C", totals.c)
                            Spacer()
                            stat("F", totals.f)
                        }
                    }
                }
                
                // Notes
                LMCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                        TextField("Optional (e.g., felt great, very hungry)", text: $notes, axis: .vertical)
                            .lineLimit(3...5)
                    }
                }
                
                // Save
                Button {
                    var meal = EFMeal(type: type, date: when, items: items, notes: notes.isEmpty ? nil : notes)
                    // Remove empty rows
                    meal.items.removeAll { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && $0.kcal <= 0 }
                    EFMealStore.shared.add(meal)
                    dismiss()
                } label: {
                    Text("Save Meal")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LMPrimaryButtonStyle(tint: .red))
                .disabled(!canSave)
                .opacity(canSave ? 1 : 0.5)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .background(Color.efCanvas.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
    
    // MARK: - Small helpers
    @ViewBuilder
    private func numberField(title: String, value: Binding<Double>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            TextField("0", value: value, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.leading)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.secondarySystemBackground)))
        }
        .frame(maxWidth: .infinity)
    }
    
    private func stat(_ label: String, _ v: Double) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            Text(v.formatted(.number.precision(.fractionLength(0))))
                .font(.title3.weight(.semibold))
        }
    }
}

#Preview {
    LogMealView()
}