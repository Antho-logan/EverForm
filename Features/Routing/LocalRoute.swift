import SwiftUI

enum LocalRoute: Identifiable {
    case training, nutrition, recovery, mobility
    case addWater, breathwork, fixPain, lookMaxing
    case profile, display, security, export, help, report

    var id: String { String(describing: self) }
}
