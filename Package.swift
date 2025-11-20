// swift-tools-version: 6.2.1
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription

let packageName: String = "AdventOfCode"

let supportedPlatforms: [SupportedPlatform] = [
    .macOS(.v26)
]

let packageDependencies: [Package.Dependency] = [
    .github("swift-argument-parser", by: "apple", .upToNextMajor(from: "1.6.2")),
]

let commonTargetDeps: [Target.Dependency] = [
    .product(name: "ArgumentParser", package: "swift-argument-parser"),
    .target(name: "AdventKit")
]

let commonSettings: [SwiftSetting] = [
    .enableUpcomingFeature     ("ExistentialAny"),
    .enableExperimentalFeature ("StrictConcurrency"),
]

let targets: [Target] = [
        // Support Library
        .target(name: "AdventKit"),

        .executableTarget(name: "calorie-counting",                dependencies: commonTargetDeps, path: "Sources/2022/01", swiftSettings: commonSettings),
        .executableTarget(name: "rock-paper-scissors",             dependencies: commonTargetDeps, path: "Sources/2022/02", swiftSettings: commonSettings),
        .executableTarget(name: "rucksack-reorganization",         dependencies: commonTargetDeps, path: "Sources/2022/03", swiftSettings: commonSettings),
        .executableTarget(name: "camp-cleanup",                    dependencies: commonTargetDeps, path: "Sources/2022/04", swiftSettings: commonSettings),
        .executableTarget(name: "supply-stacks",                   dependencies: commonTargetDeps, path: "Sources/2022/05", swiftSettings: commonSettings),
        .executableTarget(name: "tuning-trouble",                  dependencies: commonTargetDeps, path: "Sources/2022/06", swiftSettings: commonSettings),
        .executableTarget(name: "no-space-left-on-device",         dependencies: commonTargetDeps, path: "Sources/2022/07", swiftSettings: commonSettings),
        .executableTarget(name: "treetop-tree-house",              dependencies: commonTargetDeps, path: "Sources/2022/08", swiftSettings: commonSettings),
        .executableTarget(name: "trebuchet",                       dependencies: commonTargetDeps, path: "Sources/2023/01", swiftSettings: commonSettings),
        .executableTarget(name: "cube-conundrum",                  dependencies: commonTargetDeps, path: "Sources/2023/02", swiftSettings: commonSettings),
        .executableTarget(name: "gear-ratios",                     dependencies: commonTargetDeps, path: "Sources/2023/03", swiftSettings: commonSettings),
        .executableTarget(name: "scratchcards",                    dependencies: commonTargetDeps, path: "Sources/2023/04", swiftSettings: commonSettings),
        .executableTarget(name: "if-you-give-a-seed-a-fertilizer", dependencies: commonTargetDeps, path: "Sources/2023/05", swiftSettings: commonSettings),
        .executableTarget(name: "historian-hysteria",              dependencies: commonTargetDeps, path: "Sources/2024/01", swiftSettings: commonSettings),
        .executableTarget(name: "december-second",                 dependencies: commonTargetDeps, path: "Sources/2024/02", swiftSettings: commonSettings),
    ]


let package: Package = Package(
    name         : packageName,
    platforms    : supportedPlatforms,
    dependencies : packageDependencies,
    targets      : targets
)



extension Package.Dependency
{
    public static func github(_ repo: String, by user: String, _ versionRange: Range<Version>) -> PackageDescription.Package.Dependency
    {
        return Self.package(url: "https://github.com/\(user)/\(repo).git", versionRange)
    }
}


