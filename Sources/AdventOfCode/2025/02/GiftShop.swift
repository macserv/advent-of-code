//
//  GiftShop.swift
//
//  Created by Matthew Judy on 2025-12-07.
//


import Foundation
import ArgumentParser
import AdventKit
import Playgrounds


/// Day 2 : Gift Shop
///
/// # Part One
///
/// You get inside and take the elevator to its only other stop: the gift shop.
/// "Thank you for visiting the North Pole!" gleefully exclaims a nearby sign.
/// You aren't sure who is even allowed to visit the North Pole, but you know
/// you can access the lobby through here, and from there you can access the
/// rest of the North Pole base.
///
/// As you make your way through the surprisingly extensive selection, one of
/// the clerks recognizes you and asks for your help.
///
/// As it turns out, one of the younger Elves was playing on a gift shop
/// computer and managed to add a whole bunch of invalid product IDs to their
/// gift shop database! Surely, it would be no trouble for you to identify the
/// invalid product IDs for them, right?
///
/// They've even checked most of the product ID ranges already; they only have
/// a few product ID ranges (your puzzle input) that you'll need to check. For
/// example:
///
///     11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
///
/// The ranges are separated by commas (`,`); each range gives its
/// _first ID_ and _last ID_ separated by a dash (`-`).
///
/// Since the young Elf was just doing silly patterns, you can find the
/// _invalid IDs_ by looking for any ID which is made only of some sequence of
/// digits repeated twice. So, `55` (`5` twice), `6464` (`64` twice), and
/// `123123` (`123` twice) would all be invalid IDs.
///
/// None of the numbers have leading zeroes; `0101` isn't an ID at all.
/// (`101` is a _valid_ ID that you would ignore.)
///
/// Your job is to find all of the invalid IDs that appear in the given ranges.
/// In the above example:
///
/// * `11-22`                 has two invalid IDs, `11` and `22`.
/// * `95-115`                has one invalid ID,  `99`.
/// * `998-1012`              has one invalid ID,  `1010`.
/// * `1188511880-1188511890` has one invalid ID,  `1188511885`.
/// * `222220-222224`         has one invalid ID,  `222222`.
/// * `1698522-1698528`       contains no invalid IDs.
/// * `446443-446449`         has one invalid ID,  `446446`.
/// * `38593856-38593862`     has one invalid ID,  `38593859`.
/// * The rest of the ranges contain no invalid IDs.
///
/// Adding up all the invalid IDs in this example produces `1227775554`.
///
/// _What do you get if you add up all of the invalid IDs?_
@main
struct GiftShop: AsyncParsableCommand
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
//     @Option(help: "<#A value which modifes the command's behavior for Part Two#>")
//     var <#modifierOption#>: Int = 1
}


// MARK: - Command Execution

extension GiftShop
{
    enum ControlCharacter: Character
    {
        case rangeSeparator = ","
        case boundsSeparator = "-"
    }

    mutating func run() async throws
    {
        let input: AsyncCharacterSequence = URL(filePath: #filePath).deletingLastPathComponent().appending(path: "Input.txt").resourceBytes.characters

        let validRangeBuilder: (validRanges: [ClosedRange<Int>], currentSpec: String) = try await input.reduce(into: ([], ""))
        {
            if $1 != ControlCharacter.rangeSeparator.rawValue
            {
                $0.currentSpec.append($1)
                return
            }

            let rangeSpecBounds = $0.currentSpec.split(separator: ControlCharacter.boundsSeparator.rawValue)
            guard (rangeSpecBounds.count == 2) else { throw AteShit(whilst: .parsing) }

            let lowerBound = rangeSpecBounds[0]
            let upperBound = rangeSpecBounds[1]

            guard let upperBoundValue = Int(upperBound),
                  let lowerBoundValue = Int(lowerBound) else { throw AteShit(whilst: .parsing) }

            $0.currentSpec = ""
            $0.validRanges.append(lowerBoundValue...upperBoundValue)
        }

        let invalidIDs: [Int] = validRangeBuilder.validRanges.reduce(into: [])
        {
            $0.append(contentsOf: $1.reduce(into: [])
            {
                let stringValue = String($1)
                let digitCount = stringValue.count
                guard ( digitCount % 2 == 0 ) else { return }

                let midpointIndex = stringValue.index(stringValue.startIndex, offsetBy: (digitCount / 2))
                let lastIndex = stringValue.index(before: stringValue.endIndex)
                guard ( stringValue[stringValue.startIndex ..< midpointIndex] == stringValue[midpointIndex ... lastIndex] )  else { return }

                $0.append($1)
            })
        }

        print(invalidIDs.sum())
    }
}

// 23051402777
