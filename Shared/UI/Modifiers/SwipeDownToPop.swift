import SwiftUI

public struct SwipeDownToPop: ViewModifier {
    @EnvironmentObject private var router: NavigationRouter
    @GestureState private var drag: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(y: max(0, drag)) // only pull down, never up
            .gesture(
                DragGesture(minimumDistance: 8, coordinateSpace: .local)
                    .updating($drag) { value, state, _ in
                        // only track downward pulls
                        if value.translation.height > 0 { state = value.translation.height }
                    }
                    .onEnded { value in
                        if value.translation.height > 120 {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.86)) {
                                router.pop()
                            }
                        }
                    }
            )
            .animation(.spring(response: 0.35, dampingFraction: 0.9), value: drag)
    }
}

extension View {
    public func swipeDownToPop() -> some View { modifier(SwipeDownToPop()) }
}