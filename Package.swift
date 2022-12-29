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

    products: [
        .executable(name: "calorie-counting",        targets: ["2022-01"]),
        .executable(name: "rock-paper-scissors",     targets: ["2022-02"]),
        .executable(name: "rucksack-reorganization", targets: ["2022-03"]),
        .executable(name: "camp-cleanup",            targets: ["2022-04"]),
        .executable(name: "supply-stacks",           targets: ["2022-05"]),
    ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "1.2.0")),
    ],

    targets: [
        .target(name: "Shared"),
        .executableTarget(name: "2022-01", dependencies: commonDependencies, path: "Sources/2022/01", swiftSettings: commonSettings),
        .executableTarget(name: "2022-02", dependencies: commonDependencies, path: "Sources/2022/02", swiftSettings: commonSettings),
        .executableTarget(name: "2022-03", dependencies: commonDependencies, path: "Sources/2022/03", swiftSettings: commonSettings),
        .executableTarget(name: "2022-04", dependencies: commonDependencies, path: "Sources/2022/04", swiftSettings: commonSettings),
        .executableTarget(name: "2022-05", dependencies: commonDependencies, path: "Sources/2022/05", swiftSettings: commonSettings),
    ]
)
