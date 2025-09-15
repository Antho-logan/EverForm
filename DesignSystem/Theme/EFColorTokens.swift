import SwiftUI

struct EFColorTokens {
  // DARK
  var darkBG = Color(hex: "#0B0E10")
  var darkSurface = Color(hex: "#151A1E")
  var darkCard = Color(hex: "#1A1F24")
  var textPrimaryDark = Color.white
  var textSecondaryDark = Color(hex: "#D0D6DD")
  var fieldFillDark = Color(hex: "#1E2429")
  var fieldBorderDark = Color(hex: "#2A3238")

  // LIGHT (keep current look)
  var lightBG = Color(.systemBackground)
  var lightSurface = Color(.secondarySystemBackground)
  var lightCard = Color.white
  var textPrimaryLight = Color.primary
  var textSecondaryLight = Color.secondary
  var fieldFillLight = Color(.secondarySystemBackground)
  var fieldBorderLight = Color(.tertiaryLabel)

  // convenience
  var accentGreen = Color(hex: "#2BD45A") // keep current accent
}

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
    var value: UInt64 = 0; _ = scanner.scanHexInt64(&value)
    let a, r, g, b: UInt64
    switch hex.count {
      case 9: (a,r,g,b) = ((value & 0xff000000)>>24,(value & 0x00ff0000)>>16,(value & 0x0000ff00)>>8,(value & 0x000000ff))
      case 7: (a,r,g,b) = (255,(value & 0x00ff0000)>>16,(value & 0x0000ff00)>>8,(value & 0x000000ff))
      default:(a,r,g,b) = (255,0,0,0)
    }
    self = Color(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
  }
}