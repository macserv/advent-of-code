// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription


private let packageName = "AdventOfCode"

private let supportedPlatforms: [SupportedPlatform] = [
    .macOS(.v26)
]

private let packageDependencies: [Package.Dependency] = [
    .github("swift-argument-parser", by: "apple", .upToNextMajor(from: "1.6.2")),
    .github("swift-algorithms",      by: "apple", .upToNextMajor(from: "1.2.1")),
]

private let commonDependencies: [Target.Dependency] = [
    .product(name: "ArgumentParser", package: "swift-argument-parser"),
    .product(name: "Algorithms",     package: "swift-algorithms"),
    .target(name: "AdventKit")
]

private let commonSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),                  // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0335-existential-any.md
    .enableUpcomingFeature("InternalImportsByDefault"),        // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0409-access-level-on-imports.md
    .enableUpcomingFeature("MemberImportVisibility"),          // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0444-member-import-visibility.md
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),  // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
    .enableUpcomingFeature("InferIsolatedConformances"),       // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0470-isolated-conformances.md
]

private let targets: [Target] = [
    // Shared Framework
    .target(name: "AdventKit"),

    // 2022
    .executableTarget(name: "calorie-counting",        dependencies: commonDependencies, path: "Sources/AdventOfCode/2022/01", swiftSettings: commonSettings),
    .executableTarget(name: "rock-paper-scissors",     dependencies: commonDependencies, path: "Sources/AdventOfCode/2022/02", swiftSettings: commonSettings),
    .executableTarget(name: "rucksack-reorganization", dependencies: commonDependencies, path: "Sources/AdventOfCode/2022/03", swiftSettings: commonSettings),
    .executableTarget(name: "camp-cleanup",            dependencies: commonDependencies, path: "Sources/AdventOfCode/2022/04", swiftSettings: commonSettings),
    .executableTarget(name: "supply-stacks",           dependencies: commonDependencies, path: "Sources/AdventOfCode/2022/05", swiftSettings: commonSettings),
    .executableTarget(name: "tuning-trouble",          dependencies: commonDependencies, path: "Sources/AdventOfCode/2022/06", swiftSettings: commonSettings),
    .executableTarget(name: "no-space-left-on-device", dependencies: commonDependencies, path: "Sources/AdventOfCode/2022/07", swiftSettings: commonSettings),
    .executableTarget(name: "treetop-tree-house",      dependencies: commonDependencies, path: "Sources/AdventOfCode/2022/08", swiftSettings: commonSettings),

    // 2023
    .executableTarget(name: "trebuchet",                       dependencies: commonDependencies, path: "Sources/AdventOfCode/2023/01", swiftSettings: commonSettings),
    .executableTarget(name: "cube-conundrum",                  dependencies: commonDependencies, path: "Sources/AdventOfCode/2023/02", swiftSettings: commonSettings),
    .executableTarget(name: "gear-ratios",                     dependencies: commonDependencies, path: "Sources/AdventOfCode/2023/03", swiftSettings: commonSettings),
    .executableTarget(name: "scratchcards",                    dependencies: commonDependencies, path: "Sources/AdventOfCode/2023/04", swiftSettings: commonSettings),
    .executableTarget(name: "if-you-give-a-seed-a-fertilizer", dependencies: commonDependencies, path: "Sources/AdventOfCode/2023/05", swiftSettings: commonSettings),

    // 2024
    .executableTarget(name: "historian-hysteria", dependencies: commonDependencies, path: "Sources/AdventOfCode/2024/01", swiftSettings: commonSettings),
    .executableTarget(name: "red-nosed-reports",  dependencies: commonDependencies, path: "Sources/AdventOfCode/2024/02", swiftSettings: commonSettings),

    // 2025
    .executableTarget(name: "secret-entrance", dependencies: commonDependencies, path: "Sources/AdventOfCode/2025/01", swiftSettings: commonSettings),
    .executableTarget(name: "gift-shop",       dependencies: commonDependencies, path: "Sources/AdventOfCode/2025/02", swiftSettings: commonSettings),
]



let package: Package = Package(name: packageName, platforms: supportedPlatforms, dependencies: packageDependencies, targets: targets)



extension Package.Dependency
{
    public static func github(_ repo: String, by user: String, _ versionRange: Range<Version>) -> PackageDescription.Package.Dependency
    {
        return Self.package(url: "https://github.com/\(user)/\(repo).git", versionRange)
    }
}


