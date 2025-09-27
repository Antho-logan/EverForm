import SwiftUI

struct EFStatCard: View {
  struct Model: Identifiable {
    let id = UUID()
    let iconName: String   // SF Symbol
    let iconTint: Color
    let valueText: String  // e.g. "8.4K", "2661", "7h 30m", "0 ml"
    let subtitle: String   // e.g. "STEPS", "CALORIES", "SLEEP", "HYDRATION"
  }

  let model: Model

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      // Icon
      Image(systemName: model.iconName)
        .font(.system(size: 22, weight: .semibold))
        .foregroundStyle(model.iconTint)
        .padding(10)
        .background(model.iconTint.opacity(0.12), in: Circle())

      // Big value
      Text(model.valueText)
        .font(.system(size: 28, weight: .bold))       // large, like screenshot
        .foregroundStyle(Color.primary)
        .lineLimit(1)
        .minimumScaleFactor(0.7)

      // Small label
      Text(model.subtitle.uppercased())
        .font(.system(size: 12, weight: .semibold))
        .foregroundStyle(Color.secondary)
    }
    .frame(maxWidth: .infinity, minHeight: 110)        // height target ~110
    .padding(14)
    .background(
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(Color("EFCard", bundle: .main).opacity(0.92))
    )
    .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
  }
}

#Preview {
  VStack(spacing: 12) {
    EFStatCard(model: .init(iconName: "figure.walk", iconTint: .green, valueText: "8.4K", subtitle: "Steps"))
    EFStatCard(model: .init(iconName: "drop.fill", iconTint: .teal, valueText: "0 / 2661", subtitle: "Calories"))
  }
  .padding()
  .background(Color("EFBackgroundSand"))
}
