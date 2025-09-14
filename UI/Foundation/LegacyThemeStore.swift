import SwiftUI

// Legacy ThemeStore for compatibility
class ThemeStore: ObservableObject {
    static let shared = ThemeStore()
    @Published var selection: ThemeMode = .system
}