//
//  <#ChallengeName#>.swift
//
//  Created by Matthew Judy on <#YYYY-MM-DD#>.
//


import Foundation
import ArgumentParser
import AdventKit


/// Day <#Day Number#> : <#Challenge Name#>
///
/// # Part One
///
/// <#Challenge Documentation#>
@main
struct <#ChallengeName#>: AsyncParsableCommand
{
//    /// Adds a "sub-command" argument to the command, which allows the logic
//    /// to branch and handle requirements of either "Part One" or "Part Two".
//    /// The argument must be a value from this enumeration.
//    enum Mode: String, ExpressibleByArgument, CaseIterable
//    {
//        case <#modeA#>
//        case <#modeB#>
//    }
//    @Argument var mode: Mode

//    /// Adds a flag to the command, named for the behavioral difference in
//    /// "Part Two."  This allows the command's logic to branch and handle the
//    /// requirements of either "Part One" or "Part Two".
//    @Flag(help: "Search for both cardinal values ('one', 'two', ...) and integers.")
//    var <#partTwoDifference#>: Bool = false
}


// MARK: - Command Execution

extension <#ChallengeName#>
{
    mutating func run() async throws
    {
        let input: AsyncLineSequence = URL(filePath: #filePath).deletingLastPathComponent().appending(path: "Sample.txt").lines  // FileHandle.standardInput.bytes.lines
        try await input.reduce(into: []) { $0.append($1) }.forEach { print($0) }
    }
}

