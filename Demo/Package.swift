// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Demo",
    products: [
        .library(
            name: "Demo",
            targets: ["Demo"]
        ),
    ],
// begin-snippet: dependency-declaration
    dependencies: [
        .package(url: "https://github.com/jonreid/FailKit.git", from: "1.0.0"),
    ],
// end-snippet
    targets: [
        .target(
            name: "Demo",
// begin-snippet: dependency-use
            dependencies: ["FailKit"]
// end-snippet
        ),
        .testTarget(
            name: "DemoTests",
            dependencies: ["Demo"]
        ),
    ]
)
