import Foundation

enum EFRoute: Equatable, Identifiable {
    case profile, display, security, export, help, report
    case training, nutrition, recovery, mobility
    case coachTab

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
        case .coachTab: return "coachTab"
        }
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
