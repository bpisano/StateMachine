// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "StateMachine",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15),
        .macCatalyst(.v15),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "StateMachine",
            targets: ["StateMachine"]
        ),
    ],
    targets: [
        .target(name: "StateMachine"),
        .testTarget(
            name: "StateMachineTests",
            dependencies: [.target(name: "StateMachine")]
        )
    ]
)
