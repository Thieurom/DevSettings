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
            IndexedForEach(viewModel.settingGroups) { _, settingGroup in
                Section  {
                    IndexedForEach(settingGroup.settings) { _, setting in
                        settingView(setting)
                    }
                } header: {
                    if let title = settingGroup.title {
                        Text(title)
                    }
                } footer: {
                    if let description = settingGroup.description {
                        Text(description)
                    }
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
            // TODO: Check the rendered width and display accordingly
            if value.count <= 20 {
                HStack {
                    Text("\(setting.name)")
                    Spacer()
                    Text("\(value)")
                        .foregroundStyle(.secondary)
                }
                .lineLimit(1)
            } else {
                VStack(alignment: .leading) {
                    Text("\(setting.name)")
                    Text("\(value)")
                        .foregroundStyle(.secondary)
                }
                .lineLimit(1)
            }
        case let .link(url):
            Button(action: {
                UIApplication.shared.open(url)
            }, label: {
                HStack {
                    Text("\(setting.name)")
                        .lineLimit(1)
                    Spacer()
                    Image(systemName: "arrow.up.right")
                }
            })
            .disabled(!UIApplication.shared.canOpenURL(url))
        }
    }
}

#Preview {
    NavigationStack {
        DevelopmentSettingsView()
            .navigationTitle("Development Settings")
            .navigationBarTitleDisplayMode(.inline)
    }
}
