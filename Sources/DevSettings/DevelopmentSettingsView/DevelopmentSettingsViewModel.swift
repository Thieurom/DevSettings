//
//  DevelopmentSettingsViewModel.swift
//  DevSettings
//
//  Created by Doan Thieu on 24/3/25.
//

import AppTrackingTransparency
import Combine
import CoreLocation
import UIKit
import UserNotifications

class DevelopmentSettingsViewModel: ObservableObject {

    private let mainBundle = Bundle.main
    private let locationManager = CLLocationManager()
    private let notificationManager = UNUserNotificationCenter.current()
    private let userDefaults = UserDefaults.standard

    @Published private(set) var settingGroups = [SettingGroup]()
    @Published private(set) var osSettingsUrl: URL?

    init() {
        loadSettings()
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
        if setting.type == .networkDebugging {
            NetworkLoggingConfigurator.setNetworkLoggingEnabled(!isEnabled)
        }
    }
}

extension DevelopmentSettingsViewModel {

    private func loadSettings() {
        Publishers.Zip3(
            Just(loadAppInfoSettings()).eraseToAnyPublisher(),
            loadPrivacySettings(),
            Just(loadUtilitiesSettings()).eraseToAnyPublisher()
        )
        .map {
            [
                SettingGroup(
                    id: "app_info",
                    title: "App info",
                    settings: $0
                ),
                SettingGroup(
                    id: "privacy",
                    title: "Privacy",
                    settings: $1
                ),
                SettingGroup(
                    id: "utilities",
                    title: "Utilities",
                    description: "Enable network debugging and logging. Shake the device to view the logs.",
                    settings: $2
                )
            ]
        }
        .assign(to: &$settingGroups)

        osSettingsUrl = URL(string: UIApplication.openSettingsURLString)
    }
}

extension DevelopmentSettingsViewModel {

    private func loadAppInfoSettings() -> [Setting] {
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
}

extension DevelopmentSettingsViewModel {

    private func loadPrivacySettings() -> AnyPublisher<[Setting], Never> {
        Publishers.Zip3(
            Just(getAppTrackingStatusDescription()).eraseToAnyPublisher(),
            Just(getLocationStatusDescription()).eraseToAnyPublisher(),
            getNotificationStatusDescription().receive(on: DispatchQueue.main)
        )
        .map {
            [
                Setting(type: .appTracking, value: .readOnly($0)),
                Setting(type: .locationServices, value: .readOnly($1)),
                Setting(type: .notifications, value: .readOnly($2))
            ]
        }
        .eraseToAnyPublisher()
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

    private func getNotificationStatusDescription() -> AnyPublisher<String, Never> {
        Future<String, Never> { [weak self] promise in
            guard let self else {
                promise(.success("Unknown"))
                return
            }

            return notificationManager
                .getNotificationSettings { settings in
                    let statusDescription = switch settings.authorizationStatus {
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
                    promise(.success(statusDescription))
                }
        }
        .eraseToAnyPublisher()
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
}

extension DevelopmentSettingsViewModel {

    private func loadUtilitiesSettings() -> [Setting] {
        let isNetworkLoggingEnabled = SettingType.networkDebugging
            .userDefaultsKey
            .map { userDefaults.bool(forKey: $0) } ?? false

        return [
            Setting(type: .networkDebugging, value: .toggle(isNetworkLoggingEnabled))
        ]
    }
}

extension Bundle {

    fileprivate func getInfo(_ key: String) -> String? {
        infoDictionary?[key] as? String
    }
}
