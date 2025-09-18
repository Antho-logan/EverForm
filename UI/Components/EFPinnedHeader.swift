import SwiftUI

struct EFPinnedHeader<Leading: View, Trailing: View>: View {
    let title: String
    let leading: Leading
    let trailing: Trailing

    init(_ title: String,
         @ViewBuilder leading: () -> Leading,
         @ViewBuilder trailing: () -> Trailing = { EmptyView() }) {
        self.title = title
        self.leading = leading()
        self.trailing = trailing()
    }

    var body: some View {
        ZStack {
            DSColor.bg.ignoresSafeArea()
            HStack(spacing: 12) {
                leading
                Text(title)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(DSColor.textPrimary)
                Spacer()
                trailing
            }
            .padding(.horizontal, 20)
            .frame(height: 56, alignment: .bottom)
            .padding(.bottom, 8)
        }
    }
}