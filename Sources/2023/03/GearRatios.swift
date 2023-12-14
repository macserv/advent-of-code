//
//  GearRatios.swift
//
//  Created by Matthew Judy on 2023-12-14.
//


import ArgumentParser
import Foundation
import Shared


/// Day 3 : Gear Ratios
///
/// # Part One
///
/// You and the Elf eventually reach a gondola lift station; he says the
/// gondola lift will take you up to the **water source**, but this is as far
/// as he can bring you. You go inside.
///
/// It doesn't take long to find the gondolas, but there seems to be a problem:
/// they're not moving.
///
/// "Aaah!"
///
/// You turn around to see a slightly-greasy Elf with a wrench and a look of
/// surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working
/// right now; it'll still be a while before I can fix it." You offer to help.
///
/// The engineer explains that an engine part seems to be missing from the
/// engine, but nobody can figure out which one. If you can **add up all the
/// part numbers** in the engine schematic, it should be easy to work out which
/// part is missing.
///
/// The engine schematic (your puzzle input) consists of a visual
/// representation of the engine. There are lots of numbers and symbols you
/// don't really understand, but apparently **any number adjacent to a
/// symbol**, even diagonally, is a "part number" and should be included in
/// your sum.  Periods (`.`) do not count as a symbol.
///
/// Here is an example engine schematic:
///
///```
/// 467..114..
/// ...*......
/// ..35..633.
/// ......#...
/// 617*......
/// .....+.58.
/// ..592.....
/// ......755.
/// ...$.*....
/// .664.598..
/// ```
///
/// In this schematic, two numbers are **not** part numbers because they are
/// not adjacent to a symbol: `114` (top right) and `58` (middle right). All
/// other numbers are adjacent to a symbol and so are part numbers; their sum
/// is **`4361`**.
///
/// Of course, the actual engine schematic is much larger. **What is the sum of
/// all of the part numbers in the engine schematic?**
///
@main
struct GearRatios: AsyncParsableCommand
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

extension GearRatios
{
    mutating func run() async throws
    {
        let input: AsyncLineSequence = FileHandle.standardInput.bytes.lines // URL.homeDirectory.appending(path: "Desktop/input.txt").lines
        try await input.reduce(into: []) { $0.append($1) }.forEach { print($0) }
    }
}

