// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription


let commonDependencies: [Target.Dependency] = [
    .product(name: "ArgumentParser", package: "swift-argument-parser"),
    .target(name: "Shared")
]


let package: Package = Package(

    name: "AdventOfCode",

    platforms: [
        .macOS(.v13)
    ],

    products: [
        .executable(name: "calorie-counting",    targets: ["2022-01-calorie-counting"]),
        .executable(name: "rock-paper-scissors", targets: ["2022-01-rock-paper-scissors"])
    ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0")
    ],

    targets: [
        .target(name: "Shared"),
        .executableTarget(name: "2022-01-calorie-counting",    dependencies: commonDependencies, path: "Sources/2022/01"),
        .executableTarget(name: "2022-01-rock-paper-scissors", dependencies: commonDependencies, path: "Sources/2022/02")
    ]
)
