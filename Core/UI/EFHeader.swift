import SwiftUI

struct EFHeader<Trailing: View>: View {
    let title: String
    @ViewBuilder var trailing: Trailing

    init(_ title: String, @ViewBuilder trailing: () -> Trailing) {
        self.title = title
        self.trailing = trailing()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(DSColor.textPrimary)
            trailing
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .background(DSColor.appBackground) // exact app bg to remove "stripe"
    }
}

extension EFHeader where Trailing == EmptyView {
    init(_ title: String) { self.init(title) { EmptyView() } }
}

struct EFSegmentedModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .pickerStyle(.segmented)
            .background(DSColor.surface)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

extension View {
    func efSegmented() -> some View { modifier(EFSegmentedModifier()) }
}
