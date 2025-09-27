import SwiftUI

struct ModalScaffold<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: 0) {
            // grabber
            Capsule()
                .frame(width: 44, height: 5)
                .opacity(0.25)
                .padding(.top, 8)
                .padding(.bottom, 8)

            // title
            HStack {
                Text(title)
                    .font(.system(size: 34, weight: .bold)) // matches section titles
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 8)

            // content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    content
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .background(appSand.ignoresSafeArea())
    }
}

// Use the same sand color as the rest of the app
private var appSand: Color { Color("AppBackground") } // keep name consistent with your Assets