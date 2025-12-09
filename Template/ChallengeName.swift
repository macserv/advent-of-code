//
//  <#ChallengeName#>.swift
//  AdventOfCode
//
//  Created by Matthew Judy on <#YYYY-MM-DD#>.
//


import Foundation
import ArgumentParser
import AdventKit


/// Day <#DayNumber#> : <#Challenge Name#>
///
/// # Part One
///
/// <#Challenge Documentation#>
@main
struct <#ChallengeName#>: AsyncParsableCommand
{
//    /// Adds a positional argument to the command.  When `@Argument` is
//    /// applied to an enum type, its value must match one of the cases.
//    /// This can be used to create a "sub-command" for selecting "Part One"
//    /// or "Part Two" logic, with the cases named for each part's objective.
//    enum <#Mode#>: String, ExpressibleByArgument, CaseIterable
//    {
//        case <#partOneObjective#>
//        case <#partTwoObjective#>
//    }
//    @Argument(help: "<#Operating mode in which the command should be run.#>")
//    var <#modeArgument#>: <#Mode#>

//    /// Adds a flag to the command.  For most exercises, this would be named
//    /// for the behavioral difference in "Part Two," and its value will be
//    /// used to switch the logic flow to handle that behavior. Note: the name
//    /// will be converted to kebab-case (e.g., `--part-two-logic-flag``).
//    @Flag(help: "<#Do the thing differently for Part Two.#>")
//    var <#partTwoLogicFlag#>: Bool = false

//    /// Adds an option to the command, which is a flag paired with a trailing
//    /// argument.  This is useful when the difference between "Part One" and
//    /// "Part Two" can be represented with a single scalar value.  Note: the
//    /// name will be converted to kebab-case (e.g., `--modifier-option``).
//    @Option(help: "<#A value which modifes the command's behavior for Part Two#>")
//    var <#modifierOption#>: Int = 1
}


// MARK: - Command Execution

extension <#ChallengeName#>
{
    mutating func run() async throws
    {
        // Asynchronously read each line from a local file URL.
        // To reads bytes instead, replace `lines` with `resourceBytes`.
        // To read lines from `stdin`, use `FileHandle.standardInput.bytes.lines`
        // To read bytes from `stdin`, use `FileHandle.standardInput.bytes`
        let input: AsyncLineSequence = URL(filePath: #filePath).deletingLastPathComponent().appending(path: "Sample.txt").lines
        try await input.reduce(into: []) { $0.append($1) }.forEach { print($0) }
    }
}

