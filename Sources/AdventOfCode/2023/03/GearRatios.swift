//
//  GearRatios.swift
//
//  Created by Matthew Judy on 2023-12-14.
//


import ArgumentParser
import Foundation
import AdventKit


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
/// # Part Two
///
/// The engineer finds the missing part and installs it in the engine! As the
/// engine springs to life, you jump in the closest gondola, finally ready to
/// ascend to the water source.
///
/// You don't seem to be going very fast, though. Maybe something is still
/// wrong? Fortunately, the gondola has a phone labeled "help", so you pick it
/// up and the engineer answers.
///
/// Before you can explain the situation, she suggests that you look out the
/// window. There stands the engineer, holding a phone in one hand and waving
/// with the other. You're going so slowly that you haven't even left the
/// station. You exit the gondola.
///
/// The missing part wasn't the only issue - one of the gears in the engine is
/// wrong. A **gear** is any `*` symbol that is adjacent to **exactly two part
/// numbers**. Its **gear ratio** is the result of multiplying those two
/// numbers together.
///
/// This time, you need to find the gear ratio of every gear and add them all
/// up so that the engineer can figure out which gear needs to be replaced.
///
/// Consider the above engine schematic again.  In this schematic, there are
/// **two** gears. The first is in the top left; it has part numbers
/// `467` and `35`, so its gear ratio is `16345`. The second gear is in the
/// lower right; its gear ratio is `451490`. (The `*` adjacent to 617 is not a
/// gear because it is only adjacent to one part number.) Adding up all of the
/// gear ratios produces **`467835`**.
///
/// **What is the sum of all of the gear ratios in your engine schematic?**
///
@main
struct GearRatios: AsyncParsableCommand
{
    /// Adds a "sub-command" argument to the command, which allows the logic
    /// to branch and handle requirements of either "Part One" or "Part Two".
    /// The argument must be a value from this enumeration.
    enum Mode: String, ExpressibleByArgument, CaseIterable
    {
        case partNumberSum
        case gearRatioSum
    }

    @Argument var mode: Mode
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

        enum Glossary: Character
        {
            case gear = "*"
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

    var isGear: Bool { (self.symbol.character == Symbol.Glossary.gear.rawValue) && (self.numbers.count == 2) }
}


// MARK: - Command Execution

extension GearRatios
{
    typealias FoundTokens = (symbols: [Part.Symbol], identifiers: [Part.Identifier])

    mutating func run() async throws
    {
        let input: AsyncLineSequence = URL(filePath: #filePath).deletingLastPathComponent().appending(path: "Sample.txt").lines
        let (symbols, identifiers) : FoundTokens = try await input.enumerated().reduce(into: FoundTokens([], []))
        {
            foundTokens, lineIndexAndLine in let (lineIndex, line) = lineIndexAndLine

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

        switch self.mode
        {
            case .partNumberSum:
                let partNumberSum = parts.reduce(0) { $0 + $1.numbers.reduce(0, +) }
                print(partNumberSum)


            case .gearRatioSum:
                let gearRatioSum = parts.reduce(0)
                { 
                    return if ($1.isGear == false) { $0 }
                        else { ($0 + $1.numbers.reduce(1, *)) }
                }
                print(gearRatioSum)
        }
    }
}

