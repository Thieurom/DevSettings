//
//  DevelopmentSettingsViewModel.swift
//  DevSettings
//
//  Created by Doan Thieu on 24/3/25.
//

import AppTrackingTransparency
import CoreLocation
import UIKit
@preconcurrency import UserNotifications

@MainActor
class DevelopmentSettingsViewModel: ObservableObject {

    private let userDefaults = UserDefaults.standard
    private let mainBundle = Bundle.main
    private let locationManager = CLLocationManager()
    private let notificationManager = UNUserNotificationCenter.current()

    @Published private(set) var settingGroups = [SettingGroup]()
    @Published private(set) var osSettingsUrl: URL?

    init() {
        Task {
            await loadSettings()
        }
    }

    func toggleSetting(_ setting: Setting) {
        guard case .toggle(let isEnabled) = setting.value else {
            return
        }

        guard let groupIndex = settingGroups.firstIndex(
            where: { group in
                group.settings.contains(where: { $0.id == setting.id })
            }
        ) else {
            return
        }

        guard let settingIndex = settingGroups[groupIndex].settings.firstIndex(
            where: { $0.id == setting.id }) else {
            return
        }

        var updatedSettings = settingGroups[groupIndex].settings
        updatedSettings[settingIndex] = Setting(
            type: setting.type,
            value: .toggle(!isEnabled)
        )

        settingGroups[groupIndex].settings = updatedSettings

        if let userDefaultsKey = setting.type.userDefaultsKey {
            userDefaults.set(!isEnabled, forKey: userDefaultsKey)
        }

        switch setting.type {
        case .networkDebugging:
            NetworkLoggingConfigurator.setNetworkLoggingEnabled(!isEnabled)
        case .gestures:
            GesturesConfigurator.setGesturesEnabled(!isEnabled)
        default:
            break
        }
    }
}

extension DevelopmentSettingsViewModel {

    private func loadSettings() async {
        async let appInfoSettings = loadAppInfoSettings()
        async let privacySettings = loadPrivacySettings()
        async let networkLoggingSettings = loadNetworkLoggingSettings()
        async let gesturesSettings = loadGesturesSettings()

        let (appInfo, privacy, networkLogging, gestures) = await (appInfoSettings, privacySettings, networkLoggingSettings, gesturesSettings)

        settingGroups = [
            SettingGroup(
                id: "app_info",
                title: "App info",
                settings: appInfo
            ),
            SettingGroup(
                id: "privacy",
                title: "Privacy",
                settings: privacy
            ),
            SettingGroup(
                id: "network_logging",
                description: "Enable network debugging and logging. Shake the device to view the logs.",
                settings: networkLogging
            ),
            SettingGroup(
                id: "taps_gestures",
                description: "Show taps and gestures.",
                settings: gestures
            )
        ]

        osSettingsUrl = URL(string: UIApplication.openSettingsURLString)
    }

    private func loadAppInfoSettings() async -> [Setting] {
        [
            (SettingType.bundleIdentifier, mainBundle.getInfo("CFBundleIdentifier")),
            (SettingType.bundleShortVersion, mainBundle.getInfo("CFBundleShortVersionString")),
            (SettingType.bundleVersion, mainBundle.getInfo("CFBundleVersion"))
        ].compactMap { item in
            item.1.map {
                Setting(type: item.0, value: .readOnly($0))
            }
        }
    }

    private func loadPrivacySettings() async -> [Setting] {
        let notificationStatus = await getNotificationStatusDescription()

        return [
            Setting(type: .appTracking, value: .readOnly(getAppTrackingStatusDescription())),
            Setting(type: .locationServices, value: .readOnly(getLocationStatusDescription())),
            Setting(type: .notifications, value: .readOnly(notificationStatus))
        ]
    }

    private func getLocationStatusDescription() -> String {
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            "Always"
        case .authorizedWhenInUse:
            "While Using the App"
        case .denied, .restricted:
            "Never"
        case .notDetermined:
            "Ask Next Time Or When I Share"
        default:
            "Unknown location services status."
        }
    }

    private func getNotificationStatusDescription() async -> String {
        let settings = await notificationManager.notificationSettings()
        return switch settings.authorizationStatus {
        case .authorized:
            "Enabled"
        case .denied:
            "Disabled"
        case .notDetermined:
            "Not Determined"
        case .provisional:
            "Provisional"
        case .ephemeral:
            "Ephemeral"
        @unknown default:
            "Unknown"
        }
    }

    private func getAppTrackingStatusDescription() -> String {
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .authorized:
            "Allowed"
        case .notDetermined:
            "Not Determined"
        default:
            "Denied"
        }
    }

    private func loadNetworkLoggingSettings() async -> [Setting] {
        let isNetworkLoggingEnabled = SettingType.networkDebugging
            .userDefaultsKey
            .map { userDefaults.bool(forKey: $0) } ?? false

        return [
            Setting(type: .networkDebugging, value: .toggle(isNetworkLoggingEnabled))
        ]
    }

    private func loadGesturesSettings() async -> [Setting] {
        let isGesturesEnabled = SettingType.gestures
            .userDefaultsKey
            .map { userDefaults.bool(forKey: $0) } ?? false

        return [
            Setting(type: .gestures, value: .toggle(isGesturesEnabled))
        ]
    }
}

extension Bundle {

    fileprivate func getInfo(_ key: String) -> String? {
        infoDictionary?[key] as? String
    }
}
