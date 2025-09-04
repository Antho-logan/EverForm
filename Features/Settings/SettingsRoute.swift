//
//  SettingsRoute.swift
//  EverForm
//
//  Settings navigation destinations
//

import SwiftUI

enum SettingsDestination: Identifiable {
    case profile, display, security, exportData, help, reportBug
    var id: String { String(describing: self) }
}
