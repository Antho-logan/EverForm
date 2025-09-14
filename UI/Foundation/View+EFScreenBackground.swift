/// Lightweight helper to guarantee our semantic screen background and clear nav bar.
import SwiftUI

public extension View {
    func efScreenBackground() -> some View {
        self
            .background(DSColor.bg.ignoresSafeArea())
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}
