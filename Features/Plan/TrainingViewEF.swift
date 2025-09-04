import SwiftUI

struct TrainingViewEF: View, Identifiable {
    let id = UUID()
    @State private var selectedType: String = "Strength"
    @State private var duration: Int = 45
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Session") {
                    Picker("Type", selection: $selectedType) {
                        Text("Strength").tag("Strength")
                        Text("Cardio").tag("Cardio")
                        Text("HIIT").tag("HIIT")
                        Text("Mobility").tag("Mobility")
                    }
                    Stepper("Duration: \(duration) min", value: $duration, in: 5...180, step: 5)
                }
                Section("Exercises") {
                    Text("Add exercises, sets, reps…")
                        .foregroundStyle(.secondary)
                }
                Section("Notes") {
                    TextEditor(text: $notes).frame(minHeight: 100)
                }
            }
            .navigationTitle("Training")
        }
    }
}
