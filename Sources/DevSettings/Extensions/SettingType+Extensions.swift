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
            "ias_network_debugging"
        default:
            nil
        }
    }
}
