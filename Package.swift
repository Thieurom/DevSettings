// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DevSettings",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DevSettings",
            targets: ["DevSettings"]
        )
    ],
    targets: [
        .target(
            name: "DevSettings"
        ),
        .testTarget(
            name: "DevSettingsTests",
            dependencies: ["DevSettings"]
        )
    ]
)
