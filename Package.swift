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
    dependencies: [
        .package(url: "https://github.com/Thieurom/Wormholy", branch: "fix/concurrency-safe-shake-detection"),
        .package(url: "https://github.com/Thieurom/ShowTime", branch: "feature/dynamic-swizzling-control")
    ],
    targets: [
        .target(
            name: "DevSettings",
            dependencies: ["Wormholy", "ShowTime"]
        ),
        .testTarget(
            name: "DevSettingsTests",
            dependencies: ["DevSettings"]
        )
    ]
)
