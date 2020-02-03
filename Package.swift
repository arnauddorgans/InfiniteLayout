// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InfiniteLayout",
    platforms: [.iOS(.v8), .tvOS(.v9)],
    products: [
        .library(
            name: "InfiniteLayout",
            targets: ["InfiniteLayout"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CocoaProxy",
            dependencies: [],
            publicHeadersPath: "./"
        ),
        .target(
            name: "InfiniteLayout",
            dependencies: ["CocoaProxy"],
            path: "Sources",
            exclude: ["CocoaProxy"]
        ),
    ]
)
