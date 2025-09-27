import SwiftUI

struct SheetHeader: View {
    let title: String

    var body: some View {
        VStack(spacing: 12) {
            // iOS already draws a drag indicator; this just gives comfortable spacing
            Text(title)
                .font(.system(size: 34, weight: .bold))   // same as other large titles
                .foregroundColor(DSColor.textPrimary)      // theme token already used elsewhere
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}

#if DEBUG
struct SheetHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SheetHeader(title: "Breathwork")
            Spacer()
        }
        .background(DSColor.bg.ignoresSafeArea())
        .padding(.horizontal, 20)
    }
}
#endif