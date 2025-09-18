import SwiftUI

public extension View {
    /// Lightweight helper so legacy calls to `.efDarkBackground()` compile.
    /// Uses tokenized background so Light/Dark/System keep working.
    func efDarkBackground() -> some View {
        self.background(DSColor.bg)
    }

    /// Helper for card backgrounds - uses elevated background
    func efDarkCardBackground() -> some View {
        self.background(DSColor.bgElevated)
    }
}