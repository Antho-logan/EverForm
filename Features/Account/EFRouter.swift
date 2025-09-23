import Foundation
import SwiftUI

enum EFRoute: Equatable, Identifiable, Hashable {
    case profile, display, security, export, help, report
    case training, nutrition, recovery, mobility
    case fixPain, breathwork, lookMaxing, coachTab

    var id: String {
        switch self {
        case .profile: return "profile"
        case .display: return "display"
        case .security: return "security"
        case .export: return "export"
        case .help: return "help"
        case .report: return "report"
        case .training: return "training"
        case .nutrition: return "nutrition"
        case .recovery: return "recovery"
        case .mobility: return "mobility"
        case .fixPain: return "fixPain"
        case .breathwork: return "breathwork"
        case .lookMaxing: return "lookmaxing"
        case .coachTab: return "coachTab"
        }
    }
}

class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()

    func navigate(to route: EFRoute) {
        path.append(route)
    }
}

extension Notification.Name {
    static let efRoute = Notification.Name("efRoute")
}

enum EFRouter {
    static func open(_ route: EFRoute) {
        NotificationCenter.default.post(name: .efRoute, object: route)
    }
}
