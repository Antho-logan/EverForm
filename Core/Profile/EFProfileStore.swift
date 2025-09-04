import SwiftUI

final class EFProfileStore: ObservableObject {
    static let shared = EFProfileStore()
    @AppStorage("ef.profile.name") var name: String = ""
    @AppStorage("ef.profile.age") var age: Int = 29
    @AppStorage("ef.profile.height_cm") var heightCM: Int = 178
    @AppStorage("ef.profile.weight_kg") var weightKG: Double = 76
    @AppStorage("ef.profile.units") var units: String = "Metric" // "Metric" | "Imperial"
    private init() {}
}
