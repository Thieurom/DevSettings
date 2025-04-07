//
//  DevSettings+Initialize.swift
//  DevSettings
//
//  Created by Doan Thieu on 3/4/25.
//

import Foundation

public func initialize() {
    let userDefaults = UserDefaults.standard

    let isNetworkDebuggingEnabled = SettingType.networkDebugging
        .userDefaultsKey
        .map { userDefaults.bool(forKey: $0) } ?? false

    NetworkLoggingConfigurator.setNetworkLoggingEnabled(isNetworkDebuggingEnabled)

    let isGesturesEnabled = SettingType.gestures
        .userDefaultsKey
        .map { userDefaults.bool(forKey: $0) } ?? false

    GesturesConfigurator.setGesturesEnabled(isGesturesEnabled)
}
