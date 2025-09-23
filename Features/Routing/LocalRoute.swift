import SwiftUI

enum LocalRoute: Identifiable, Hashable {
    case training, nutrition, recovery, mobility
    case addWater, breathwork, fixPain, lookMaxing
    case profile, display, security, export, help, report

    var id: String { String(describing: self) }
}
