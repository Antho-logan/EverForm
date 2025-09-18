import SwiftUI

/// Runtime dynamic colors for System(Default) ONLY.
/// If your Assets.xcassets are text-tracked, replace this with proper color sets and delete this file. // TODO
enum EFPaletteLight {
    static let background    = Color(UIColor { t in
        t.userInterfaceStyle == .dark ? UIColor.clear : UIColor(hex: 0xE8D2B7)
    })
    static let card          = Color(UIColor { t in
        t.userInterfaceStyle == .dark ? UIColor.clear : UIColor(hex: 0xF3E6D6)
    })
    static let stroke        = Color(UIColor { t in
        t.userInterfaceStyle == .dark ? UIColor.clear : UIColor(hex: 0xE3D3C2)
    })
    static let textPrimary   = Color(UIColor { t in
        t.userInterfaceStyle == .dark ? UIColor.clear : UIColor.black
    })
    static let textSecondary = Color(UIColor { t in
        t.userInterfaceStyle == .dark ? UIColor.clear : UIColor(hex: 0x4F463E)
    })
}

// Minimal UIKit hex helper
private extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}