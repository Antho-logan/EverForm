import SwiftUI

struct MobilityViewEF: View, Identifiable {
    let id = UUID()
    @State private var region: String = "Back"
    @State private var duration: Int = 15
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Focus") {
                    Picker("Region", selection: $region) {
                        Text("Neck").tag("Neck")
                        Text("Shoulders").tag("Shoulders")
                        Text("Back").tag("Back")
                        Text("Hips").tag("Hips")
                        Text("Knees").tag("Knees")
                        Text("Ankles").tag("Ankles")
                    }
                    Stepper("Duration: \(duration) min", value: $duration, in: 5...90, step: 5)
                }
                Section("Routines") {
                    Toggle("Walk", isOn: .constant(false))
                    Toggle("Dynamic stretch", isOn: .constant(false))
                    Toggle("Foam roll", isOn: .constant(false))
                }
                Section("Notes") {
                    TextEditor(text: $notes).frame(minHeight: 100)
                }
            }
            .tint(.purple) // Mobility = purple
            .navigationTitle("Mobility")
        }
    }
}
