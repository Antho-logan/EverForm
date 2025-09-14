import XCTest
import SwiftUI
@testable import EverForm

final class AppearanceSelectorTests: XCTestCase {
    
    func testLightThemeExactHexValues() {
        // Given: Light theme is active
        let themeManager = ThemeManager.shared
        let originalScheme = themeManager.scheme
        
        // When: Set to light mode
        themeManager.scheme = .light
        
        // Then: Background colors should match exact hex values
        XCTAssertEqual(DSColor.bg, Color(hex: "#F2F2F7"), "Window background should be #F2F2F7 (iOS Gray 6)")
        XCTAssertEqual(DSColor.bgElevated, Color.white, "Grouped background should be white")
        XCTAssertEqual(DSColor.barBackground, Color.white, "Navbar background should be white")
        XCTAssertEqual(DSColor.borderHairline, Color.clear, "Separator should be clear")
        
        // Restore original scheme
        themeManager.scheme = originalScheme
    }
    
    func testDarkThemeUnchanged() {
        // Given: Dark theme is active
        let themeManager = ThemeManager.shared
        let originalScheme = themeManager.scheme
        
        // When: Set to dark mode
        themeManager.scheme = .dark
        
        // Then: Colors should remain unchanged from previous work
        XCTAssertEqual(DSColor.bg, Color(hex: "#121417"), "Dark background should be #121417")
        XCTAssertEqual(DSColor.bgElevated, Color(hex: "#15181C"), "Dark elevated should be #15181C")
        XCTAssertEqual(DSColor.barBackground, Color(hex: "#121417"), "Dark navbar should be #121417")
        
        // Restore original scheme
        themeManager.scheme = originalScheme
    }
    
    func testSystemThemeUnchanged() {
        // Given: System theme is active
        let themeManager = ThemeManager.shared
        let originalScheme = themeManager.scheme
        
        // When: Set to system mode
        themeManager.scheme = .system
        
        // Then: Colors should remain unchanged (beige theme)
        XCTAssertEqual(DSColor.bg, Color(hex: "#EAD6BF"), "System background should be unchanged")
        XCTAssertEqual(DSColor.bgElevated, Color(hex: "#F6F0E6"), "System elevated should be unchanged")
        XCTAssertEqual(DSColor.barBackground, Color(hex: "#EAD6BF"), "System navbar should be unchanged")
        
        // Restore original scheme
        themeManager.scheme = originalScheme
    }
    
    func testAppearanceStoreThemeManagerSync() {
        // Given: Appearance store and ThemeManager
        let appearanceStore = AppearanceStore()
        let themeManager = ThemeManager.shared
        let originalScheme = themeManager.scheme
        
        // When: Set appearance store to light
        appearanceStore.mode = .light
        
        // Then: ThemeManager should sync
        XCTAssertEqual(themeManager.scheme, .light, "ThemeManager should sync with AppearanceStore")
        
        // When: Set appearance store to dark
        appearanceStore.mode = .dark
        
        // Then: ThemeManager should sync
        XCTAssertEqual(themeManager.scheme, .dark, "ThemeManager should sync with AppearanceStore")
        
        // When: Set appearance store to system
        appearanceStore.mode = .system
        
        // Then: ThemeManager should sync
        XCTAssertEqual(themeManager.scheme, .system, "ThemeManager should sync with AppearanceStore")
        
        // Restore original scheme
        themeManager.scheme = originalScheme
    }
    
    func testAppThemeLightPaletteConsistency() {
        // Given: Light appearance
        let lightPalette = AppTheme.palette(for: .light, appearance: .light)
        
        // Then: Should match new light background colors
        XCTAssertEqual(lightPalette.bg, Color(hex: "#F2F2F7"), "AppTheme light bg should be #F2F2F7")
        XCTAssertEqual(lightPalette.surface, Color.white, "AppTheme light surface should be white")
        XCTAssertEqual(lightPalette.card, Color.white, "AppTheme light card should be white")
    }
}