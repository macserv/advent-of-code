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
/// * `95-115`                has one invalid ID,           `99`.
/// * `998-1012`              has one invalid ID,         `1010`.
/// * `1188511880-1188511890` has one invalid ID,   `1188511885`.
/// * `222220-222224`         has one invalid ID,       `222222`.
/// * `1698522-1698528`       contains no invalid IDs.
/// * `446443-446449`         has one invalid ID,       `446446`.
/// * `38593856-38593862`     has one invalid ID,     `38593859`.
/// * The rest of the ranges contain no invalid IDs.
///
/// Adding up all the invalid IDs in this example produces `1227775554`.
///
/// _What do you get if you add up all of the invalid IDs?_
///
/// # Part Two
///
/// The clerk quickly discovers that there are still invalid IDs in the ranges
/// in your list. Maybe the young Elf was doing other silly patterns as well?
///
/// Now, an ID is invalid if it is made only of some sequence of digits
/// repeated _at least_ twice. So, `12341234` (`1234` two times), `123123123`
/// (`123` three times), `1212121212` (`12` five times), and `1111111`
/// (`1` seven times) are all invalid IDs.
///
/// From the same example as before:
///
/// * `11-22`                 still has two invalid IDs,  `11` and   `22`.
/// * `95-115`                now   has two invalid IDs,  `99` and  `111`.
/// * `998-1012`              now   has two invalid IDs, `999` and `1010`.
/// * `1188511880-1188511890` still has one invalid ID,      `1188511885`.
/// * `222220-222224`         still has one invalid ID,          `222222`.
/// * `1698522-1698528`       still contains no invalid IDs.
/// * `446443-446449`         still has one invalid ID,          `446446`.
/// * `38593856-38593862`     still has one invalid ID,        `38593859`.
/// * `565653-565659`         now   has one invalid ID,          `565656`.
/// * `824824821-824824827`   now   has one invalid ID,       `824824824`.
/// * `2121212118-2121212124` now   has one invalid ID,      `2121212121`.
///
/// Adding up all the invalid IDs in this example produces `4174379265`.
///
/// _What do you get if you add up all of the invalid IDs using
/// these new rules?_

@main
struct GiftShop: AsyncParsableCommand
{
    /// Available options for identifying invalid product identifiers.
    enum InvalidIDCondition: String, ExpressibleByArgument, CaseIterable
    {
        case oneRepetition
        case oneOrMoreRepetitions

        var defaultValueDescription: String
        {
            switch self
            {
                case .oneRepetition        : "Evaluated IDs are invalid if comprised of a sequence of digits repeating once (e.g., 11, 1212, 123123)."
                case .oneOrMoreRepetitions : "Evaluated IDs are invalid if comprised of a sequence of digits repeating any number of times (e.g., 11, 111, 1212, 121212, 123123, 123123123)."
            }
        }
    }

    /// Subcommand to determine which logic should be used to identify invalid
    /// product IDs.
    @Argument()
    var invalidIDCondition: InvalidIDCondition
}


// MARK: - Command Execution

extension GiftShop
{
    mutating func run() async throws
    {
        // Stream the input as async characters. Filter (input file) newlines.
        let asyncCharacters: AsyncCharacterSequence = URL(filePath: #filePath)
            .deletingLastPathComponent()
            .appending(path: "Input.txt")
            .resourceBytes
            .characters

        let asyncRanges = AsyncProductIDRangeParsingSequence(stream: asyncCharacters)

        let sumOfInvalidIDs: some UnsignedInteger = try await asyncRanges.reduce(into: 0)
        {
            sumResult, range in
            sumResult += range.reduce(into: 0)
            {
                rangeSumResult, productID in
                if productID.isInvalid(checkingFor: self.invalidIDCondition) { rangeSumResult += productID }
            }
        }

        print(sumOfInvalidIDs)
    }
}


/// An async sequence that parses comma-separated range specs from a character stream.
struct AsyncProductIDRangeParsingSequence: AsyncSequence
{
    struct AsyncIterator: AsyncIteratorProtocol
    {
        enum ParsingCharacter: Character, RawRepresentable
        {
            case rangeSeparator  = ","
            case boundsSeparator = "-"
            case newline         = "\n"
        }


        var iterator: AsyncCharacterSequence<URL.AsyncBytes>.AsyncIterator
        var buffer = ""


        mutating func next() async throws -> ClosedRange<UInt>?
        {
            while let char = try await self.iterator.next()
            {
                switch char
                {
                    case ParsingCharacter.rangeSeparator.rawValue:
                        let rangeSpec = self.buffer
                        self.buffer = ""
                        return try self.rangeFromSpec(rangeSpec)

                    case ParsingCharacter.newline.rawValue: continue

                    default: self.buffer.append(char)
                }
            }

            // If no more characters, return any buffer contents.
            if ( false == self.buffer.isEmpty )
            {
                defer { self.buffer = "" }
                return try self.rangeFromSpec(self.buffer)
            }

            return nil
        }


        private func rangeFromSpec(_ rangeSpec: String) throws -> ClosedRange<UInt>
        {
            let rangeBounds = rangeSpec.split(separator: ParsingCharacter.boundsSeparator.rawValue)
            guard rangeBounds.count == 2 else { throw AteShit(whilst: .parsing) }

            guard let lowerBoundValue = UInt(rangeBounds[0]),
                  let upperBoundValue = UInt(rangeBounds[1]) else { throw AteShit(whilst: .parsing) }

            let range = (lowerBoundValue...upperBoundValue)

            return range
        }
    }


    let stream: AsyncCharacterSequence<URL.AsyncBytes>

    func makeAsyncIterator() -> AsyncIterator { AsyncIterator(iterator: stream.makeAsyncIterator()) }
}




extension UnsignedInteger
{
    func isInvalid(checkingFor: GiftShop.InvalidIDCondition) -> Bool
    {
        switch checkingFor
        {
            case .oneRepetition:
                let stringValue = String(self)
                guard ( (stringValue.count % 2) == 0 ) else { return false }
                return stringValue.isPeriodic(period: (stringValue.count / 2))

            case .oneOrMoreRepetitions:
                return self.isPeriodic
        }
    }
}


