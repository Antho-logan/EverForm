//
//  ProfileView.swift
//  EverForm
//
//  User profile settings
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("ef.profile.name") private var name: String = ""
    @AppStorage("ef.profile.age") private var age: Int = 29
    @AppStorage("ef.profile.height_cm") private var heightCM: Int = 178
    @AppStorage("ef.profile.weight_kg") private var weightKG: Double = 76
    @AppStorage("ef.profile.units") private var units: String = "Metric"

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.green)
                    Text("Profile").font(.largeTitle.bold()).foregroundStyle(DSColor.textPrimary)
                    Spacer()
                }.padding(.horizontal, 4)

                EFCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Basics").font(.subheadline).foregroundStyle(DSColor.textSecondary)

                        TextField("Name", text: $name)
                            .textContentType(.name)
                            .padding(12)
                            .background(DSColor.surface, in: RoundedRectangle(cornerRadius: 12))
                            .foregroundStyle(DSColor.textPrimary)

                        HStack(spacing: 12) {
                            Stepper("Age: \(age)", value: $age, in: 5...100)
                            Spacer()
                        }.foregroundStyle(DSColor.textPrimary)

                        HStack(spacing: 12) {
                            Stepper("Height: \(heightCM) cm", value: $heightCM, in: 100...230)
                            Spacer()
                        }.foregroundStyle(DSColor.textPrimary)

                        HStack(spacing: 12) {
                            Slider(value: $weightKG, in: 35...160, step: 0.5)
                            Text("\(String(format: "%.1f", weightKG)) kg")
                                .monospacedDigit().foregroundStyle(DSColor.textSecondary)
                        }
                        Picker("Units", selection: $units) {
                            Text("Metric").tag("Metric")
                            Text("Imperial").tag("Imperial")
                        }.pickerStyle(.segmented)
                    }
                }

                EFCard {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Goals").font(.subheadline).foregroundStyle(DSColor.textSecondary)
                        Text("Set targets for calories, protein, steps, and weekly training in a later release.")
                            .foregroundStyle(DSColor.textPrimary)
                    }
                }
            }
            .padding(16)
        }
        .background(DSColor.appBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}
