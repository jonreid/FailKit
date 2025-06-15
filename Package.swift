// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "FailKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "FailKit",
            targets: ["FailKit"]),
    ],
    targets: [
        .target(
            name: "FailKit"),
        .testTarget(
            name: "FailKitTests",
            dependencies: ["FailKit"]
        ),
    ]
)
