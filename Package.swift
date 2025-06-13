// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "FailKit",
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
