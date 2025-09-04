import SwiftUI

struct RecoveryViewEF: View, Identifiable {
    let id = UUID()
    @State private var bedtime = Date()
    @State private var windDown: Int = 20
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Sleep") {
                    DatePicker("Bedtime", selection: $bedtime, displayedComponents: .hourAndMinute)
                    Stepper("Wind-down: \(windDown) min", value: $windDown, in: 0...120, step: 5)
                }
                Section("Recovery Routines") {
                    Toggle("Breathwork", isOn: .constant(false))
                    Toggle("Stretching", isOn: .constant(false))
                    Toggle("Cold shower", isOn: .constant(false))
                }
                Section("Notes") {
                    TextEditor(text: $notes).frame(minHeight: 100)
                }
            }
            .tint(.blue) // Recovery = blue
            .navigationTitle("Recovery")
        }
    }
}
