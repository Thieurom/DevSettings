//
//  SettingGroup.swift
//  DevSettings
//
//  Created by Doan Thieu on 2/4/25.
//

import Foundation

struct SettingGroup: Identifiable {

    let id: String
    let name: String?
    let description: String?
    var settings: [Setting]

    init(
        id: String = UUID().uuidString,
        title: String? = nil,
        description: String? = nil,
        settings: [Setting]
    ) {
        self.id = id
        self.name = title
        self.description = description
        self.settings = settings
    }
}
