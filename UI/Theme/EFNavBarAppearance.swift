import SwiftUI

// MARK: - Navigation Bar Appearance Helper
enum EFNavBarAppearance {
    
    /// Apply navigation bar styling based on color scheme
    /// - Parameter scheme: The current color scheme
    static func apply(for scheme: ColorScheme) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        // Apply white text for dark mode, keep defaults for light/system
        if scheme == .dark {
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        // Apply the appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}