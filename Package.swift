// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription


extension Package.Dependency
{
    public static func github(_ repo: String, by user: String, _ versionRange: Range<Version>) -> PackageDescription.Package.Dependency
    {
        return Self.package(url: "https://github.com/\(user)/\(repo).git", versionRange)
    }
}


let commonDependencies: [Target.Dependency] = [
    .product(name: "ArgumentParser", package: "swift-argument-parser"),
    .target(name: "AdventKit")
]

let commonSettings: [SwiftSetting] = [
    .enableUpcomingFeature    ("BareSlashRegexLiterals"),
    .enableUpcomingFeature    ("ForwardTrailingClosures"),
    .enableUpcomingFeature    ("ExistentialAny"),
    .enableExperimentalFeature("StrictConcurrency"),
]


let package: Package = Package(

    name: "AdventOfCode",

    platforms: [
        .macOS(.v13)
    ],

    products: [
        // 2024
        .executable(name: "historian-hysteria", targets: ["HistorianHysteria"]),
        .executable(name: "december-second",    targets: ["DecemberSecond"]),
    ],

    dependencies: [
        .github("swift-argument-parser", by: "apple", .upToNextMajor(from: "1.5.0")),
    ],

    targets: [
        .target(name: "AdventKit"),

        // 2022
        .executableTarget(name: "calorie-counting",        dependencies: commonDependencies, path: "Sources/2022/01", swiftSettings: commonSettings),
        .executableTarget(name: "rock-paper-scissors",     dependencies: commonDependencies, path: "Sources/2022/02", swiftSettings: commonSettings),
        .executableTarget(name: "rucksack-reorganization", dependencies: commonDependencies, path: "Sources/2022/03", swiftSettings: commonSettings),
        .executableTarget(name: "camp-cleanup",            dependencies: commonDependencies, path: "Sources/2022/04", swiftSettings: commonSettings),
        .executableTarget(name: "supply-stacks",           dependencies: commonDependencies, path: "Sources/2022/05", swiftSettings: commonSettings),
        .executableTarget(name: "tuning-trouble",          dependencies: commonDependencies, path: "Sources/2022/06", swiftSettings: commonSettings),
        .executableTarget(name: "no-space-left-on-device", dependencies: commonDependencies, path: "Sources/2022/07", swiftSettings: commonSettings),
        .executableTarget(name: "treetop-tree-house",      dependencies: commonDependencies, path: "Sources/2022/08", swiftSettings: commonSettings),

        // 2023
        .executableTarget(name: "trebuchet",                       dependencies: commonDependencies, path: "Sources/2023/01", swiftSettings: commonSettings),
        .executableTarget(name: "cube-conundrum",                  dependencies: commonDependencies, path: "Sources/2023/02", swiftSettings: commonSettings),
        .executableTarget(name: "gear-ratios",                     dependencies: commonDependencies, path: "Sources/2023/03", swiftSettings: commonSettings),
        .executableTarget(name: "scratchcards",                    dependencies: commonDependencies, path: "Sources/2023/04", swiftSettings: commonSettings),
        .executableTarget(name: "if-you-give-a-seed-a-fertilizer", dependencies: commonDependencies, path: "Sources/2023/05", swiftSettings: commonSettings),

        // 2024
        .executableTarget(name: "HistorianHysteria", dependencies: commonDependencies, path: "Sources/2024/01", swiftSettings: commonSettings),
        .executableTarget(name: "DecemberSecond",    dependencies: commonDependencies, path: "Sources/2024/02", swiftSettings: commonSettings),
    ]
)
