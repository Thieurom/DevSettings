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

class DevelopmentSettingsViewModel: ObservableObject {

    private let userDefaults = UserDefaults.standard
    private let mainBundle = Bundle.main
    private let locationManager = CLLocationManager()
    private let notificationManager = UNUserNotificationCenter.current()

    private let reloadSettingsPublisher = CurrentValueSubject<Void, Never>(())

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

        switch setting.type {
        case .networkDebugging:
            NetworkLoggingConfigurator.setNetworkLoggingEnabled(!isEnabled)
        case .gestures:
            GesturesConfigurator.setGesturesEnabled(!isEnabled)
        default:
            break
        }
    }

    func reloadSettings() {
        reloadSettingsPublisher.send(())
    }
}

extension DevelopmentSettingsViewModel {

    private func loadSettings() {
        Publishers.CombineLatest4(
            Just(loadAppInfoSettings()).eraseToAnyPublisher(),
            loadPrivacySettings(),
            Just(loadNetworkLoggingSettings()).eraseToAnyPublisher(),
            Just(loadGesturesSettings()).eraseToAnyPublisher()
        )
        .map { appInfo, privacy, networkLogging, gestures in
            [
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
        }
        .receive(on: DispatchQueue.main)
        .assign(to: &$settingGroups)

        osSettingsUrl = URL(string: UIApplication.openSettingsURLString)
    }

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

    private func loadPrivacySettings() -> AnyPublisher<[Setting], Never> {
        Publishers.CombineLatest3(
            getAppTrackingStatus(),
            getLocationStatus(),
            getNotificationStatus()
        )
        .map { appTracking, locationServices, notifications in
            [
                Setting(type: .appTracking, value: .readOnly(appTracking)),
                Setting(type: .locationServices, value: .readOnly(locationServices)),
                Setting(type: .notifications, value: .readOnly(notifications))
            ]
        }
        .eraseToAnyPublisher()
    }

    private func getLocationStatus() -> AnyPublisher<String, Never> {
        reloadSettingsPublisher
            .map { [weak self] _ in
                guard let self else {
                    return "Unknown"
                }
                return switch locationManager.authorizationStatus {
                case .authorizedAlways:
                    "Always"
                case .authorizedWhenInUse:
                    "While Using"
                case .denied, .restricted:
                    "Never"
                case .notDetermined:
                    "Ask Next Time"
                default:
                    "Unknown"
                }
            }
            .eraseToAnyPublisher()
    }

    private func getNotificationStatus() -> AnyPublisher<String, Never> {
        reloadSettingsPublisher
            .map {
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
            .switchToLatest()
            .eraseToAnyPublisher()
    }

    private func getAppTrackingStatus() -> AnyPublisher<String, Never> {
        reloadSettingsPublisher
            .map { _ in
                switch ATTrackingManager.trackingAuthorizationStatus {
                case .authorized:
                    "Allowed"
                case .notDetermined:
                    "Not Determined"
                default:
                    "Not Allowed"
                }
            }
            .eraseToAnyPublisher()
    }

    private func loadNetworkLoggingSettings() -> [Setting] {
        let isNetworkLoggingEnabled = SettingType.networkDebugging
            .userDefaultsKey
            .map { userDefaults.bool(forKey: $0) } ?? false

        return [
            Setting(type: .networkDebugging, value: .toggle(isNetworkLoggingEnabled))
        ]
    }

    private func loadGesturesSettings() -> [Setting] {
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
