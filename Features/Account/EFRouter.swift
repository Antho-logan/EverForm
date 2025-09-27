import Foundation
import SwiftUI

// MARK: - Routes
enum EFRoute: Equatable, Identifiable, Hashable {
    case profile, display, security, export, help, report
    case training, nutrition, recovery, mobility
    case painArea(PainArea), painAssessment(PainAssessment), breathwork, lookMaxing, coachTab

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
        case .painArea(let area): return "painArea_\(area.rawValue)"
        case .painAssessment(_): return "painAssessment"
        case .breathwork: return "breathwork"
        case .lookMaxing: return "lookmaxing"
        case .coachTab: return "coachTab"
        }
    }

    var presentsAsSheet: Bool {
        switch self {
        case .breathwork, .lookMaxing, .painArea(_), .painAssessment(_):
            return true
        default:
            return false
        }
    }
}

@MainActor
final class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var modal: EFModal? = nil
    @Published var presentedRoute: EFRoute? = nil

    func push(_ route: EFRoute) {
        path.append(route)
        print("[ROUTER] push:", route, "count:", path.count)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        if path.count > 0 {
            path.removeLast(path.count)
        }
        print("[ROUTER] popToRoot -> count:", path.count)
    }

    func presentModal(_ modal: EFModal) {
        self.modal = modal
        print("[ROUTER] presentModal:", modal.title)
    }

    func dismissModal() {
        if modal != nil {
            print("[ROUTER] dismissModal:", modal?.title ?? "unknown")
            modal = nil
        }
    }

    func present(_ route: EFRoute) {
        presentedRoute = route
        print("[ROUTER] present:", route)
    }

    func dismissPresented() {
        if presentedRoute != nil {
            print("[ROUTER] dismissPresented:", presentedRoute?.id ?? "unknown")
            presentedRoute = nil
        }
    }

    
    // Legacy method for backward compatibility
    func go(_ route: EFRoute) {
        push(route)
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

extension EFRoute: CustomDebugStringConvertible {
    var debugDescription: String {
        return "EFRoute.\(self.id)"
    }
}
