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
            ForEach(viewModel.settingGroups) { settingGroup in
                Section {
                    ForEach(settingGroup.settings) { setting in
                        settingView(setting)
                    }
                } header: {
                    if let name = settingGroup.name {
                        Text(name)
                    }
                } footer: {
                    if let description = settingGroup.description {
                        Text(description)
                    }
                }
            }

            if let url = viewModel.osSettingsUrl {
                Section {
                    openSettingsButton(url)
                } footer: {
                    Text("This will open the iOS Settings app.")
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    public init() {
        _viewModel = .init(wrappedValue: DevelopmentSettingsViewModel())
    }
}

extension DevelopmentSettingsView {

    @ViewBuilder private func settingView(_ setting: Setting) -> some View {
        switch setting.value {
        case let .readOnly(value):
            HStack {
                Text("\(setting.type.name)")
                Spacer()
                Text("\(value)")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        case let .toggle(isEnabled):
            Toggle(
                setting.type.name,
                isOn: .init(
                    get: { isEnabled },
                    set: { _ in viewModel.toggleSetting(setting) }
                )
            )
        }
    }

    func openSettingsButton(_ settingsUrl: URL) -> some View {
        Button(action: {
            UIApplication.shared.open(settingsUrl)
        }, label: {
            HStack {
                Text("Open Settings")
                    .lineLimit(1)
                Spacer()
                Image(systemName: "arrow.up.right")
            }
        })
        .disabled(!UIApplication.shared.canOpenURL(settingsUrl))
    }
}

#Preview {
    NavigationStack {
        DevelopmentSettingsView()
            .navigationTitle("Development Settings")
            .navigationBarTitleDisplayMode(.inline)
    }
}
