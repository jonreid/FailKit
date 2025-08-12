// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "FailKit",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_12),
        .tvOS(.v10),
        .watchOS(.v3),
    ],
    products: [
        .library(
            name: "FailKit",
            targets: ["FailKit"],
        ),
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
