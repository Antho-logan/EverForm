import SwiftUI

struct DestinationMapperView: View {
  let route: EFRoute
  @EnvironmentObject private var router: NavigationRouter

  @ViewBuilder
  var body: some View {
    switch route {
    case .breathwork:
      BreathworkView()
        .toolbar(.hidden, for: .navigationBar)
        .background(DSColor.bg.ignoresSafeArea())
    case .painArea(let area):
        FixPainDetailView(area: area)
            .toolbar(.hidden, for: .navigationBar)
            .background(DSColor.bg.ignoresSafeArea())
    case .painAssessment(let assessment):
        FixPainDetailView(area: assessment.area)
            .toolbar(.hidden, for: .navigationBar)
            .background(DSColor.bg.ignoresSafeArea())
    case .lookMaxing:
      LookMaxingView()
        .toolbar(.hidden, for: .navigationBar)
        .background(DSColor.bg.ignoresSafeArea())
    default:
      UnhandledRouteView(name: String(describing: route))
        .modifier(EFScreenStyle(title: String(describing: route)))
        .background(DSColor.bg.ignoresSafeArea())
    }
  }
}


struct EFScreenStyle: ViewModifier {
  let title: String
  func body(content: Content) -> some View {
    content
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.large)
      .toolbarBackground(DSColor.bg, for: .navigationBar)
      .toolbarBackground(.visible, for: .navigationBar)
  }
}

struct UnhandledRouteView: View {
  let name: String
  var body: some View {
    ZStack {
      DSColor.bg.ignoresSafeArea()
      Text("Unsupported Feature")
        .font(.headline).padding()
    }
  }
}

#if DEBUG
struct DestinationMapperView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      DestinationMapperView(route: .breathwork)
    }
  }
}
#endif