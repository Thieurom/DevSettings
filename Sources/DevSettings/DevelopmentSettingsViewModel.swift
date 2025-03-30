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

    lazy private var mainBundle = Bundle.main
    lazy private var locationManager = CLLocationManager()
    lazy private var notificationManager = UNUserNotificationCenter.current()

    @Published private(set) var settingGroups = [SettingGroup]()

    init() {
        loadSettings()
    }
}

extension DevelopmentSettingsViewModel {

    private func loadSettings() {
        Publishers.Zip3(
            Just(createAppInfoSettings()).eraseToAnyPublisher(),
            createPrivacySettings(),
            Just(createLinkSettings()).eraseToAnyPublisher()
        )
        .map {
            [
                SettingGroup(title: "App info", settings: $0),
                SettingGroup(title: "Privacy", settings: $1),
                SettingGroup(
                    description: "This will open the iOS Settings app.",
                    settings: $2
                )
            ]
        }
        .assign(to: &$settingGroups)
    }
}

extension DevelopmentSettingsViewModel {

    private func createAppInfoSettings() -> [Setting] {
        [
            ("Bundle Identifier", mainBundle.getInfo("CFBundleIdentifier")),
            ("Bundle Short Version", mainBundle.getInfo("CFBundleShortVersionString")),
            ("Bundle Version", mainBundle.getInfo("CFBundleVersion"))
        ].compactMap { item in
            item.1.map {
                Setting(name: item.0, value: .readOnly($0))
            }
        }
    }
}

extension DevelopmentSettingsViewModel {

    private func createPrivacySettings() -> AnyPublisher<[Setting], Never> {
        Publishers.Zip3(
            Just(getAppTrackingStatusDescription()).eraseToAnyPublisher(),
            Just(getLocationStatusDescription()).eraseToAnyPublisher(),
            getNotificationStatusDescription().receive(on: DispatchQueue.main)
        )
        .map {
            [
                Setting(name: "App Tracking", value: .readOnly($0)),
                Setting(name: "Location Services", value: .readOnly($1)),
                Setting(name: "Notifications", value: .readOnly($2))
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
    }}

extension DevelopmentSettingsViewModel {

    private func createLinkSettings() -> [Setting] {
        [UIApplication.openSettingsURLString]
            .compactMap {
                URL(string: $0)
            }.map {
                Setting(name: "Open Settings", value: .link($0))
            }
    }
}

extension Bundle {

    fileprivate func getInfo(_ key: String) -> String? {
        infoDictionary?[key] as? String
    }
}
