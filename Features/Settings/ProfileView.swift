//
//  ProfileView.swift
//  EverForm
//
//  User profile settings
//

import SwiftUI

struct ProfileView: View {
    @State private var name: String = "Your Name"
    @State private var email: String = "you@example.com"
    @State private var heightCM: Double = 180
    @State private var weightKG: Double = 75
    @State private var birthdate: Date = Calendar.current.date(byAdding: .year, value: -25, to: .now) ?? .now
    @State private var unitsMetric: Bool = true
    @State private var dailyStepGoal: Int = 8000
    @State private var dailyCalGoal: Int = 2600

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header card
                VStack(spacing: 12) {
                    Circle().fill(DSColor.cardElevated).frame(width: 88, height: 88)
                        .overlay(Image(systemName: "person.fill").font(.system(size: 36)).foregroundStyle(DSColor.textPrimary))
                    Text(name).font(.title2).foregroundStyle(DSColor.textPrimary)
                    Text(email).foregroundStyle(DSColor.textSecondary)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(DSColor.card)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: Color.black.opacity(ColorScheme.current == .light ? 0.06 : 0), radius: 12, x: 0, y: 6)

                SettingsSectionCard(title: "Basics") {
                    VStack(spacing: 12) {
                        TextField("Name", text: $name)
                            .textInputAutocapitalization(.words)
                            .padding().background(DSColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding().background(DSColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        DatePicker("Birthdate", selection: $birthdate, displayedComponents: .date)
                            .tint(.green)
                            .padding().background(DSColor.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        Toggle(isOn: $unitsMetric) {
                            Text("Use Metric Units").foregroundStyle(DSColor.textPrimary)
                        }
                        .padding().background(DSColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }

                SettingsSectionCard(title: "Body") {
                    VStack(spacing: 12) {
                        Stepper(value: $heightCM, in: 120...220, step: 1) {
                            Text("Height: \(Int(heightCM)) cm")
                        }
                        .padding().background(DSColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        Stepper(value: $weightKG, in: 40...160, step: 1) {
                            Text("Weight: \(Int(weightKG)) kg")
                        }
                        .padding().background(DSColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }

                SettingsSectionCard(title: "Goals") {
                    VStack(spacing: 12) {
                        Stepper(value: $dailyStepGoal, in: 1000...25000, step: 500) {
                            Text("Daily Step Goal: \(dailyStepGoal)")
                        }
                        .padding().background(DSColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                        Stepper(value: $dailyCalGoal, in: 1200...4500, step: 50) {
                            Text("Daily Calorie Target: \(dailyCalGoal) kcal")
                        }
                        .padding().background(DSColor.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }

                SettingsSectionCard(title: "Connected Services") {
                    VStack(spacing: 12) {
                        SettingsRow(icon: "heart.fill", title: "Apple Health", subtitle: "Sync steps, sleep & hydration") {
                            Toggle("", isOn: .constant(true)).labelsHidden()
                        }
                        SettingsRow(icon: "figure.run.circle.fill", title: "Strava", subtitle: "Import workouts") {
                            Image(systemName: "chevron.right").foregroundStyle(DSColor.textSecondary)
                        }
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Profile")
        .background(DSColor.appBackground.ignoresSafeArea())
    }
}
