import SwiftUI

// Renamed to avoid conflict with UI/Foundation/EFInputField
struct EFDesignSystemInputField: View {
  @EnvironmentObject private var theme: EFThemeManager
  @Environment(\.colorScheme) private var colorScheme
  var placeholder: String
  @Binding var text: String
  var axis: Axis = .vertical

  var body: some View {
    let dark = theme.isDark(colorScheme)
    TextField("", text: $text, axis: axis, prompt: Text(placeholder).foregroundColor(dark ? theme.tokens.textSecondaryDark : theme.tokens.textSecondaryLight))
      .foregroundColor(dark ? theme.tokens.textPrimaryDark : theme.tokens.textPrimaryLight)
      .textInputAutocapitalization(.sentences)
      .padding(14)
      .background(RoundedRectangle(cornerRadius: 14).fill(dark ? theme.tokens.fieldFillDark : theme.tokens.fieldFillLight))
      .overlay(RoundedRectangle(cornerRadius: 14).stroke(dark ? theme.tokens.fieldBorderDark : theme.tokens.fieldBorderLight, lineWidth: 1))
  }
}