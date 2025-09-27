import SwiftUI

/// Minimal bridge exposing the colors the UI expects.
/// We map to the existing Design System tokens so visuals stay consistent.
enum EFTheme {
    static var appBackground: Color { DSColor.bg }                  // main screen background
    static var cardBackground: Color { DSColor.card }               // card tiles
    static var cardShadow: Color { DSColor.shadow }                 // if used
    static var accent: Color { DSColor.accentPrimary }              // primary accent
}
