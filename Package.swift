// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InfiniteLayout",
    platforms: [.iOS(.v9), .tvOS(.v9)],
    products: [
        .library(
            name: "InfiniteLayout",
            targets: ["InfiniteLayout"]),
        .library(
            name: "RxInfiniteLayout",
            targets: ["RxInfiniteLayout"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.1.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", .upToNextMajor(from: "5.0.0")),
    ],
    targets: [
        .target(
            name: "CocoaProxy",
            dependencies: [],
            publicHeadersPath: "./"
        ),
        .target(
            name: "InfiniteLayout",
            dependencies: ["CocoaProxy"]
        ),
        .target(
            name: "RxInfiniteLayout",
            dependencies: ["InfiniteLayout", "RxSwift", "RxCocoa", "RxDataSources"],
            path: "Sources/Rx"
        ),
    ]
)
