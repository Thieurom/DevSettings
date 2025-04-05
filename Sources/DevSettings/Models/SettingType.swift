//
//  SettingType.swift
//  DevSettings
//
//  Created by Doan Thieu on 31/3/25.
//

enum SettingType {

    // App Info
    case bundleIdentifier
    case bundleVersion
    case bundleShortVersion

    // Privacy
    case locationServices
    case notifications
    case appTracking

    // Utilities
    case networkDebugging
    case gestures

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
        case .gestures:
            return "Taps and Gestures"
        }
    }
}
