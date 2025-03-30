//
//  Setting.swift
//  DevSettings
//
//  Created by Doan Thieu on 28/3/25.
//

import Foundation

struct Setting {

    let name: String
    let value: SettingValueType
}

enum SettingValueType {

    case readOnly(String)
    case link(URL)
}

struct SettingGroup {

    let title: String?
    let description: String?
    let settings: [Setting]

    init(title: String? = nil, description: String? = nil, settings: [Setting]) {
        self.title = title
        self.description = description
        self.settings = settings
    }
}
