import XCTest
import SwiftUI
@testable import EverForm

final class DarkPaletteTests: XCTestCase {
    
    func testDarkBackgroundPaletteHexValues() {
        // Given: Dark theme is active
        let themeManager = ThemeManager.shared
        let originalScheme = themeManager.scheme
        
        // When: Set to dark mode
        themeManager.scheme = .dark
        
        // Then: Background colors should match exact hex values
        XCTAssertEqual(DSColor.bg, Color(hex: "#121417"), "Window/root background should be #121417")
        XCTAssertEqual(DSColor.bgElevated, Color(hex: "#15181C"), "Grouped background should be #15181C")
        XCTAssertEqual(DSColor.barBackground, Color(hex: "#121417"), "Navbar background should be #121417")
        
        // Card should remain unchanged (not a background in this context)
        XCTAssertEqual(DSColor.card, Color(hex: "#161A1F"), "Card should remain #161A1F")
        
        // Restore original scheme
        themeManager.scheme = originalScheme
    }
    
    func testLightThemeUnchanged() {
        // Given: Light theme is active
        let themeManager = ThemeManager.shared
        let originalScheme = themeManager.scheme
        
        // When: Set to light mode
        themeManager.scheme = .light
        
        // Then: Colors should remain unchanged
        XCTAssertEqual(DSColor.bg, Color(hex: "#F6F7FA"), "Light background should be unchanged")
        XCTAssertEqual(DSColor.bgElevated, Color.white, "Light elevated should be white")
        XCTAssertEqual(DSColor.card, Color.white, "Light card should be white")
        
        // Restore original scheme
        themeManager.scheme = originalScheme
    }
    
    func testSystemThemeUnchanged() {
        // Given: System theme is active
        let themeManager = ThemeManager.shared
        let originalScheme = themeManager.scheme
        
        // When: Set to system mode
        themeManager.scheme = .system
        
        // Then: Colors should remain unchanged from previous System theme work
        XCTAssertEqual(DSColor.bg, Color(hex: "#EAD6BF"), "System background should be unchanged")
        XCTAssertEqual(DSColor.bgElevated, Color(hex: "#F6F0E6"), "System elevated should be unchanged")
        XCTAssertEqual(DSColor.card, Color(hex: "#FFFFFF"), "System card should be white")
        
        // Restore original scheme
        themeManager.scheme = originalScheme
    }
    
    func testAppThemeDarkPaletteConsistency() {
        // Given: Dark appearance
        let darkPalette = AppTheme.palette(for: .dark, appearance: .dark)
        
        // Then: Should match new dark background colors
        XCTAssertEqual(darkPalette.bg, Color(hex: "#121417"), "AppTheme dark bg should be #121417")
        XCTAssertEqual(darkPalette.surface, Color(hex: "#15181C"), "AppTheme dark surface should be #15181C")
        XCTAssertEqual(darkPalette.card, Color(hex: "#1A1E22"), "AppTheme dark card should be #1A1E22")
    }
}