// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription


private typealias AdventTargetSpec = (executableName: String, pathSuffix: String)


private let packageName = "AdventOfCode"

private let supportedPlatforms: [SupportedPlatform] = [
    .macOS(.v26)
]

private let packageDependencies: [Package.Dependency] = [
    .github("swift-argument-parser", by: "apple", .upToNextMajor(from: "1.6.2")),
    .github("swift-algorithms",      by: "apple", .upToNextMajor(from: "1.2.1")),
]

private let commonTargetDependencies: [Target.Dependency] = [
    .product(name: "ArgumentParser", package: "swift-argument-parser"),
    .product(name: "Algorithms",     package: "swift-algorithms"),
    .target(name: "AdventKit")
]

private let commonTargetSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),                  // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0335-existential-any.md
    .enableUpcomingFeature("InternalImportsByDefault"),        // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0409-access-level-on-imports.md
    .enableUpcomingFeature("MemberImportVisibility"),          // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0444-member-import-visibility.md
    .enableUpcomingFeature("NonisolatedNonsendingByDefault"),  // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0461-async-function-isolation.md
    .enableUpcomingFeature("InferIsolatedConformances"),       // https://github.com/swiftlang/swift-evolution/blob/main/proposals/0470-isolated-conformances.md
]

private let adventTargetSpecs: [AdventTargetSpec] = [
    // 2022
    ("calorie-counting",                "2022/01"),
    ("rock-paper-scissors",             "2022/02"),
    ("rucksack-reorganization",         "2022/03"),
    ("camp-cleanup",                    "2022/04"),
    ("supply-stacks",                   "2022/05"),
    ("tuning-trouble",                  "2022/06"),
    ("no-space-left-on-device",         "2022/07"),
    ("treetop-tree-house",              "2022/08"),

    // 2023
    ("trebuchet",                       "2023/01"),
    ("cube-conundrum",                  "2023/02"),
    ("gear-ratios",                     "2023/03"),
    ("scratchcards",                    "2023/04"),
    ("if-you-give-a-seed-a-fertilizer", "2023/05"),

    // 2024
    ("historian-hysteria",              "2024/01"),
    ("red-nosed-reports",               "2024/02"),

    // 2025
    ("secret-entrance",                 "2025/01"),
    ("gift-shop",                       "2025/02"),
    ("lobby",                           "2025/03"),
]

private let targets: [Target] = ([ .target(name: "AdventKit") ] + adventTargetSpecs.map {
    .executableTarget(
        name: $0.executableName,
        dependencies: commonTargetDependencies,
        path: "Sources/AdventOfCode/\($0.pathSuffix)",
        swiftSettings: commonTargetSettings
    )
})



let package: Package = Package(
    name: packageName,
    platforms: supportedPlatforms,
    dependencies: packageDependencies,
    targets: targets
)



extension Package.Dependency
{
    public static func github(_ repo: String, by user: String, _ versionRange: Range<Version>) -> PackageDescription.Package.Dependency
    {
        return Self.package(url: "https://github.com/\(user)/\(repo).git", versionRange)
    }
}


