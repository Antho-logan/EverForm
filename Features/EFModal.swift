import SwiftUI

enum EFModal: Identifiable, Hashable {
    case breathwork, fixPain, lookMaxing
    var id: String { String(describing: self) }
    var title: String {
        switch self {
        case .breathwork: return "Breathwork"
        case .fixPain: return "Fix Pain"
        case .lookMaxing: return "Look Maxing"
        }
    }
}