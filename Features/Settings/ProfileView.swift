//
//  ProfileView.swift
//  EverForm
//
//  User profile settings
//

import SwiftUI

struct ProfileView: View {
    @State private var fullName: String = "Your Name"
    @State private var email: String = "you@example.com"
    @State private var unit: String = "Metric"
    @State private var dob = Date(timeIntervalSince1970: 0)
    @State private var height: String = ""
    @State private var weight: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            Text("Profile")
                .font(.system(.largeTitle, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)

            ScrollView {
                VStack(spacing: 16) {
                    AvatarCard()
                    EFCard {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Full name").frame(width: 110, alignment: .leading)
                                TextField("Full name", text: $fullName)
                                    .textFieldStyle(.plain)
                                    .padding(.horizontal, 12).padding(.vertical, 10)
                                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                            Divider()
                            HStack {
                                Text("Email").frame(width: 110, alignment: .leading)
                                TextField("Email", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .textFieldStyle(.plain)
                                    .padding(.horizontal, 12).padding(.vertical, 10)
                                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                        }
                    }
                    EFCard {
                        Picker("Units", selection: $unit) {
                            Text("Metric").tag("Metric")
                            Text("Imperial").tag("Imperial")
                        }
                        .pickerStyle(.segmented)
                    }
                    EFCard {
                        VStack(spacing: 12) {
                            DatePicker("Date of birth", selection: $dob, displayedComponents: .date)
                            Divider()
                            HStack {
                                Text("Height").frame(width: 110, alignment: .leading)
                                TextField(unit == "Metric" ? "cm" : "in", text: $height)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.plain)
                                    .padding(.horizontal, 12).padding(.vertical, 10)
                                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                            Divider()
                            HStack {
                                Text("Weight").frame(width: 110, alignment: .leading)
                                TextField(unit == "Metric" ? "kg" : "lb", text: $weight)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.plain)
                                    .padding(.horizontal, 12).padding(.vertical, 10)
                                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                        }
                    }
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        dismiss()
                    } label: {
                        Text("Save changes").bold().frame(maxWidth: .infinity).padding(.vertical, 14)
                    }
                    .buttonStyle(.borderedProminent)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding(20)
            }
        }
        .background(DSColor.appBackground.ignoresSafeArea())
    }
}

private struct AvatarCard: View {
    var body: some View {
        EFCard {
            HStack(spacing: 16) {
                Circle().fill(Color.gray.opacity(0.2)).frame(width: 56, height: 56)
                    .overlay(Image(systemName: "person.fill").font(.title2).foregroundStyle(.secondary))
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your profile").font(.headline)
                    Text("Tap Save to persist changes").foregroundStyle(DSColor.textSecondary)
                        .font(.subheadline)
                }
                Spacer()
            }
        }
    }
}
