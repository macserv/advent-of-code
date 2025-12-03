//
//  DecemberSecond.swift
//
//  Created by Matthew Judy on 2024-12-02.
//


import ArgumentParser
import Foundation
import AdventKit


/// Day 2 : Red-Nosed Reports
///
/// # Part One
///
/// <#Challenge Documentation#>
@main
struct DecemberSecond: AsyncParsableCommand
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

extension DecemberSecond
{
    mutating func run() async throws
    {
        let maxDelta: Int = 3
        let tolerant: Bool = true
        let input: AsyncLineSequence = URL(filePath: #filePath).deletingLastPathComponent().appending(path: "Input.txt").lines  // FileHandle.standardInput.bytes.lines
        let safeReportCount: Int = try await input.reduce(into: 0)
        {
            currentCount, line in
            var levels: [Int] = try line.split(separator: " ").map
            {
                guard let level = Int($0) else { throw AteShit(whilst: .parsing, "Encountered non-integer level '\($0)' in line '\(line)'.") }
                return level
            }

            if ( try false == levels.isSafe(maxDelta: maxDelta, singleFaultTolerant: tolerant) ) { print("REJECTED!") ; return }
            currentCount += 1
        }

        print(safeReportCount)
    }
}


enum ReportError: Error
{
    case unsafeChange(index: Int)
    case noChange(index: Int)
    case invalidDirection
}


extension Array where Element: SignedInteger
{
    enum Direction
    {
        case ascending
        case descending
        case noChange

        enum Error: Swift.Error
        {
            case nilFirstOrLast
            case tooShort
        }
    }

    var direction: Direction
    {
        get throws
        {
            guard self.count >= 2 else { throw Direction.Error.tooShort }
            guard let first = self.first, let last = self.last else { throw Direction.Error.nilFirstOrLast }
            switch (first, last)
            {
                case (let first, let last) where first < last: return .ascending
                case (let first, let last) where first > last: return .descending
                default: return .noChange
            }
        }
    }

    func isSafe(maxDelta: Element, singleFaultTolerant: Bool = false) throws -> Bool
    {
        print()
        print(self)
        do
        {
            let direction = try self.direction
            guard ( direction != .noChange ) else { throw ReportError.invalidDirection }

            try zip(self.enumerated(), self.dropFirst()).forEach
            {
                let delta = abs($0.element - $1)
                guard (1...maxDelta).contains(delta) else
                {
                    throw ReportError.unsafeChange(index: $0.offset + 1)
                }
                switch direction
                {
                    case .ascending  : guard ( $0.element < $1 ) else { throw ReportError.unsafeChange(index: ($0.offset + 1)) }
                    case .descending : guard ( $0.element > $1 ) else { throw ReportError.unsafeChange(index: ($0.offset + 1)) }
                    case .noChange   : fatalError("This should be unreachable.")
                }
            }
        }
        catch ReportError.unsafeChange(let index)
        {

            if ( false == singleFaultTolerant ) { print("Unsafe change at \(index)... REJECTED! 😤😤😤") ; return false }

            print("Unsafe change at \(index)!")
//            var currentRemoved = self ; self.remove(at: (index))
            return try self.isSafe(maxDelta: maxDelta, singleFaultTolerant: false)
        }
        catch ReportError.invalidDirection
        {
            if ( false == singleFaultTolerant ) { return false }

//            self.remove(at: 0)
            return try self.isSafe(maxDelta: maxDelta, singleFaultTolerant: false)
        }
        print("Safe!")
        return true
    }
}
