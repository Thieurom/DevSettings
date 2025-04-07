//
//  GesturesConfigurator.swift
//  DevSettings
//
//  Created by Doan Thieu on 6/4/25.
//

import SwiftUI
@preconcurrency import ShowTime

struct GesturesConfigurator {

    static func setGesturesEnabled(_ enabled: Bool) {
        if enabled {
            ShowTime.fillColor = .gestureFill
            ShowTime.strokeColor = .gestureStroke
            ShowTime.strokeWidth = 1.0
            ShowTime.disappearDelay = 0.1
            ShowTime.enabled = .always
        } else {
            ShowTime.enabled = .never
        }
    }
}
