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
    /// <#Enumeration for argument which activates "Part Two" behavior#>
    enum Mode: String, ExpressibleByArgument, CaseIterable
    {
        case modeA
        case modeB
    }

    @Option(help: "<#Argument used to activate “Part Two” behavior.#>")
    var mode: Mode
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

