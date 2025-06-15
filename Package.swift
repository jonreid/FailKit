// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FailKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v13),
        .tvOS(.v13),
        .watchOS(.v2),
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
