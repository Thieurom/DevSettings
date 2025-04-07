//
//  SettingType+Extensions.swift
//  DevSettings
//
//  Created by Doan Thieu on 4/4/25.
//

extension SettingType {

    var userDefaultsKey: String? {
        switch self {
        case .networkDebugging:
            "devsettings_network_debugging"
        case .gestures:
            "devsettings_gestures"
        default:
            nil
        }
    }
}
