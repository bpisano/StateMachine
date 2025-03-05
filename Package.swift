// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "StateMachine",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .watchOS(.v6),
        .tvOS(.v13),
        .macCatalyst(.v13),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "StateMachine",
            targets: ["StateMachine"]
        ),
    ],
    targets: [
        .target(name: "StateMachine")
    ]
)
