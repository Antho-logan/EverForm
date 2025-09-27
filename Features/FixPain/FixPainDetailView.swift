import SwiftUI

struct FixPainDetailView: View {
  let area: PainArea

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        Text(area.title)
          .font(.system(size: 32, weight: .bold))
          .foregroundStyle(Color("EFTitle", bundle: .main))
        Text(area.subtitle)
          .font(.title3)
          .foregroundStyle(Color("EFSubtitle", bundle: .main))

        // TODO: plug existing content for this area here (stretches/programs)
        // Keep a neutral card until hooked up:
        RoundedRectangle(cornerRadius: 16)
          .fill(Color("EFCard", bundle: .main).opacity(0.7))
          .frame(maxWidth: .infinity, minHeight: 160)
          .overlay(Text("Program content for \(area.title)").font(.headline))
      }
      .padding(20)
    }
    .background(Color("EFBackgroundSand", bundle: .main).ignoresSafeArea())
  }
}