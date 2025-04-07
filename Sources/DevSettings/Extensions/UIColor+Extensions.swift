//
//  UIColor+Extensions.swift
//  DevSettings
//
//  Created by Doan Thieu on 6/4/25.
//

import UIKit

extension UIColor {

    static var gestureFill: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? .init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.7)
            : .init(red: 0.85, green: 0.85, blue: 0.85, alpha: 0.7)
        }
    }

    static var gestureStroke: UIColor {
        UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? .init(red: 0.35, green: 0.35, blue: 0.35, alpha: 0.8)
            : .init(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        }
    }
}
