import SwiftUI

struct EFColorTokens {
  // DARK
  var darkBG = Color(red: 11/255, green: 14/255, blue: 16/255)
  var darkSurface = Color(red: 21/255, green: 26/255, blue: 30/255)
  var darkCard = Color(red: 26/255, green: 31/255, blue: 36/255)
  var textPrimaryDark = Color.white
  var textSecondaryDark = Color(red: 208/255, green: 214/255, blue: 221/255)
  var fieldFillDark = Color(red: 30/255, green: 36/255, blue: 41/255)
  var fieldBorderDark = Color(red: 42/255, green: 50/255, blue: 56/255)

  // LIGHT (keep current look)
  var lightBG = Color(.systemBackground)
  var lightSurface = Color(.secondarySystemBackground)
  var lightCard = Color.white
  var textPrimaryLight = Color.primary
  var textSecondaryLight = Color.secondary
  var fieldFillLight = Color(.secondarySystemBackground)
  var fieldBorderLight = Color(.tertiaryLabel)

  // convenience
  var accentGreen = Color(red: 43/255, green: 212/255, blue: 90/255)
}