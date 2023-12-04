// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription


let commonDependencies: [Target.Dependency] = [
    .product(name: "ArgumentParser", package: "swift-argument-parser"),
    .target(name: "Shared")
]

let commonSettings: [SwiftSetting] = [
    .unsafeFlags(["-enable-bare-slash-regex"])
]


let package: Package = Package(

    name: "AdventOfCode",

    platforms: [
        .macOS(.v13)
    ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "1.2.0"))
    ],

    targets: [
        .target(name: "Shared"),
        .executableTarget(name: "calorie-counting",        dependencies: commonDependencies, path: "Sources/2022/01", swiftSettings: commonSettings),
        .executableTarget(name: "rock-paper-scissors",     dependencies: commonDependencies, path: "Sources/2022/02", swiftSettings: commonSettings),
        .executableTarget(name: "rucksack-reorganization", dependencies: commonDependencies, path: "Sources/2022/03", swiftSettings: commonSettings),
        .executableTarget(name: "camp-cleanup",            dependencies: commonDependencies, path: "Sources/2022/04", swiftSettings: commonSettings),
        .executableTarget(name: "supply-stacks",           dependencies: commonDependencies, path: "Sources/2022/05", swiftSettings: commonSettings),
        .executableTarget(name: "tuning-trouble",          dependencies: commonDependencies, path: "Sources/2022/06", swiftSettings: commonSettings),
        .executableTarget(name: "no-space-left-on-device", dependencies: commonDependencies, path: "Sources/2022/07", swiftSettings: commonSettings),
        .executableTarget(name: "treetop-tree-house",      dependencies: commonDependencies, path: "Sources/2022/08", swiftSettings: commonSettings),
    ]
)
