//
//  DevelopmentSettingsViewModel.swift
//  DevSettings
//
//  Created by Doan Thieu on 24/3/25.
//

import UIKit

class DevelopmentSettingsViewModel: ObservableObject {

    @Published private(set) var settingGroups: [SettingGroup]

    init() {
        let bundle = Bundle.main
        let appInfoSettings = [
            ("Bundle Identifier", bundle.getInfo("CFBundleIdentifier")),
            ("Bundle Short Version", bundle.getInfo("CFBundleShortVersionString")),
            ("Bundle Version", bundle.getInfo("CFBundleVersion"))
        ].compactMap { item in
            item.1.map {
                Setting(name: item.0, value: .readOnly($0))
            }
        }

        let linkSettings = [
            UIApplication.openSettingsURLString
        ].compactMap {
            URL(string: $0)
        }.map {
            Setting(name: "Open Settings", value: .link($0))
        }

        settingGroups = [
            SettingGroup(settings: appInfoSettings),
            SettingGroup(
                description: "This will open the iOS Settings app.",
                settings: linkSettings
            )
        ]
    }
}

extension Bundle {

    fileprivate func getInfo(_ key: String) -> String? {
        infoDictionary?[key] as? String
    }
}
