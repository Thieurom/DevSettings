//
//  NetworkLoggingConfigurator.swift
//  DevSettings
//
//  Created by Doan Thieu on 4/4/25.
//

@preconcurrency import WormholySwift

struct NetworkLoggingConfigurator {

    static func setNetworkLoggingEnabled(_ enabled: Bool) {
        Wormholy.setEnabled(enabled)
        Wormholy.shakeEnabled = enabled
    }
}
