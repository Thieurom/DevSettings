//
//  DevelopmentSettingsViewModel.swift
//  DevSettings
//
//  Created by Doan Thieu on 24/3/25.
//

import Combine
import Foundation

struct Setting {

    let name: String
    let value: String
}

class DevelopmentSettingsViewModel: ObservableObject {

    @Published private(set) var settingItems: [Setting]

    init() {
        let bundle = Bundle.main
        settingItems = [
            ("Bundle Identifier", bundle.getInfo("CFBundleIdentifier")),
            ("Bundle Short Version", bundle.getInfo("CFBundleShortVersionString")),
            ("Bundle Version", bundle.getInfo("CFBundleVersion"))
        ].compactMap { item in
            item.1.flatMap { Setting(name: item.0, value: $0) }
        }
    }
}

extension Bundle {

    func getInfo(_ key: String) -> String? {
        infoDictionary?[key] as? String
    }
}
