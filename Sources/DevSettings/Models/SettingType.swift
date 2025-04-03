//
//  SettingType.swift
//  DevSettings
//
//  Created by Doan Thieu on 31/3/25.
//

enum SettingType: String {

    // App Info
    case bundleIdentifier = "bundle_identifier"
    case bundleVersion = "bundle_version"
    case bundleShortVersion = "bundle_short_version"

    // Privacy
    case locationServices = "location_services"
    case notifications = "notifications"
    case appTracking = "app_tracking"

    // Utilities
    case networkDebugging = "network_debugging"

    var name: String {
        switch self {
        case .bundleIdentifier:
            return "Bundle Identifier"
        case .bundleVersion:
            return "Bundle Version"
        case .bundleShortVersion:
            return "Bundle Short Version"
        case .locationServices:
            return "Location Services"
        case .notifications:
            return "Notifications"
        case .appTracking:
            return "App Tracking"
        case .networkDebugging:
            return "Network Debugging"
        }
    }
}
