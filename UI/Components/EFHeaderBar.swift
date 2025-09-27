import SwiftUI

struct EFHeaderBar: View {
    var title: String
    var onBack: () -> Void

    var body: some View {
        ZStack {
            // Centered title
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)

            // Back arrow
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(12)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
                Spacer()
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 16)
        .background(DSColor.bg)
    }
}