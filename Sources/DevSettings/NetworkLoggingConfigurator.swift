//
//  NetworkLoggingConfigurator.swift
//  DevSettings
//
//  Created by Doan Thieu on 4/4/25.
//

import WormholySwift

struct NetworkLoggingConfigurator {

    static func setNetworkLoggingEnabled(_ enabled: Bool) {
        Wormholy.setEnabled(enabled)
        Wormholy.setShakeEnabled(enabled)
    }
}
