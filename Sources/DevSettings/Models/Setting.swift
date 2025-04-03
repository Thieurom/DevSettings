//
//  Setting.swift
//  DevSettings
//
//  Created by Doan Thieu on 28/3/25.
//

import Foundation

struct Setting {

    let type: SettingType
    let value: SettingValue

    init(type: SettingType, value: SettingValue) {
        self.type = type
        self.value = value
    }
}

extension Setting: Identifiable {

    var id: SettingType { type }
}
