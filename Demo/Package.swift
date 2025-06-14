// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Demo",
    products: [
        .library(
            name: "Demo",
            targets: ["Demo"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/jonreid/FailKit.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Demo",
            dependencies: ["FailKit"]
        ),
        .testTarget(
            name: "DemoTests",
            dependencies: ["Demo"]
        ),
    ]
)
