//
//  <#ChallengeName#>.swift
//
//  Created by Matthew Judy on <#YYYY-MM-DD#>.
//


import ArgumentParser
import Foundation
import Shared


/// Day <#Day Number#> : <#Challenge Name#>
///
/// # Part One
///
/// <#Challenge Documentation#>
@main
struct <#ChallengeName#>: AsyncParsableCommand
{
//    /// Adds a `--mode` option to the command, which allows the command's logic
//    /// to branch and handle requirements of either "Part One" or "Part Two".
//    /// The option must be followed by a value from this enumeration.
//    enum Mode: String, ExpressibleByArgument, CaseIterable
//    {
//        case <#modeA#>
//        case <#modeB#>
//    }
//    @Option(help: "'<#modeA#>' or '<#modeB#>'")
//    var mode: Mode

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
        let input: AsyncLineSequence = FileHandle.standardInput.bytes.lines // URL.homeDirectory.appending(path: "Desktop/input.txt").lines
        try await input.reduce(into: []) { $0.append($1) }.forEach { print($0) }
    }
}

