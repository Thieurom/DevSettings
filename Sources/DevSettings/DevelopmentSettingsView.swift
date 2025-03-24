//
//  DevelopmentSettingsView.swift
//  DevSettings
//
//  Created by Doan Thieu on 24/3/25.
//

import SwiftUI

public struct DevelopmentSettingsView: View {

    @StateObject private var viewModel: DevelopmentSettingsViewModel

    public var body: some View {
        List {
            Section {
                ForEach(viewModel.settingItems, id: \.name) { setting in
                    HStack {
                        Text("\(setting.name)")
                        Spacer()
                        Text("\(setting.value)")
                            .foregroundStyle(.secondary)
                    }
                    .lineLimit(1)
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    public init() {
        _viewModel = .init(wrappedValue: DevelopmentSettingsViewModel())
    }
}

#Preview {
    NavigationStack {
        DevelopmentSettingsView()
            .navigationTitle("Development Settings")
            .navigationBarTitleDisplayMode(.inline)
    }
}
