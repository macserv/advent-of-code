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


struct Part
{
    struct Symbol
    {
        struct Location: Equatable, CustomStringConvertible
        {
            let line        : Int
            let column      : Int
            var description : String { "(L:\(self.line), C:\(self.column)" }
        }

        let character : Character
        let location  : Location
    }

    struct Identifier
    {
        let number : Int
        let border : [Symbol.Location]
    }

    let symbol  : Symbol
    let numbers : [Int]

    init(symbol: Symbol, identifiers: [Identifier])
    {
        self.symbol  = symbol
        self.numbers = identifiers.map(\.number)
    }
}


// MARK: - Command Execution

extension GearRatios
{
    mutating func run() async throws
    {
        let input: AsyncLineSequence = URL.homeDirectory.appending(path: "Desktop/input.txt").lines
        let lines = try await input.reduce(into: [])
        {
            $0.append($1)
        }

        typealias FoundTokens = (symbols: [Part.Symbol], identifiers: [Part.Identifier])

        let (symbols, identifiers) : FoundTokens = lines.enumerated().reduce(into: FoundTokens([], []))
        {
            foundTokens, lineIndexAndline in let (lineIndex, line) = lineIndexAndline

            // Find symbols in line.
            line.ranges(of: /[^\d\.]/).forEach
            {
                symbolRange in

                let symbolIndex : Int = line.distance(from: line.startIndex, to: symbolRange.lowerBound)

                foundTokens.symbols.append(Part.Symbol(character: line[symbolRange].first!, location: Part.Symbol.Location(line: lineIndex, column: symbolIndex)))
            }
            
            // Find identifiers (integers) in line, and the border around them.
            line.ranges(of: /\d+/).forEach
            {
                idRange in

                let idStartIndex    : Int        = line.distance(from: line.startIndex, to: idRange.lowerBound)
                let idEndIndex      : Int        = line.distance(from: line.startIndex, to: idRange.upperBound)
                let borderRange     : ClosedRange<Int> = ((idStartIndex - 1)...idEndIndex).clamped(to: (0...(line.count - 1)))

                let startLocation   = Part.Symbol.Location(line: lineIndex, column: borderRange.lowerBound)
                let endLocation     = Part.Symbol.Location(line: lineIndex, column: borderRange.upperBound)
                let aboveLocations  : [Part.Symbol.Location] = borderRange.map { .init(line: (lineIndex - 1), column: $0) }
                let belowLocations  : [Part.Symbol.Location] = borderRange.map { .init(line: (lineIndex + 1), column: $0) }
                let borderLocations : [Part.Symbol.Location] = ( [startLocation, endLocation] + aboveLocations + belowLocations )

                foundTokens.identifiers.append(Part.Identifier(number: Int(line[idRange])!, border: borderLocations))
            }
        }

        let parts: [Part] = symbols.reduce(into: [])
        {
            parts, symbol in
            parts.append( Part(
                symbol: symbol,
                identifiers: identifiers.filter {
                    $0.border.contains(symbol.location)
                })
            )
        }

        let partNumberSum: Int = parts.flatMap(\.numbers).reduce(0, +)

        print(partNumberSum)
    }
}

