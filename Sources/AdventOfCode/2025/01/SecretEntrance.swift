//
//  SecretEntrance.swift
//
//  Created by Matthew Judy on 2025-12-07.
//


import Foundation
import ArgumentParser
import AdventKit
import Playgrounds


/// Day 1 : Secret Entrance
///
/// # Part One
///
/// The Elves have good news and bad news.
///
/// The good news is that they've discovered project management!  This has
/// given them the tools they need to prevent their usual Christmas emergency.
/// For example, they now know that the North Pole decorations need to be
/// finished soon so that other critical tasks can start on time.
///
/// The bad news is that they've realized they have a __different__ emergency:
/// according to their resource planning, none of them have any time left to
/// decorate the North Pole!
///
/// To save Christmas, the Elves need you to __finish decorating the North Pole
/// by December 12th.__
///
/// Collect stars by solving puzzles.  Two puzzles will be made available on
/// each day; the second puzzle is unlocked when you complete the first.
/// Each puzzle grants **one star**.  Good luck!
///
/// You arrive at the secret entrance to the North Pole base ready to start
/// decorating.  Unfortunately, the __password__ seems to have been changed,
/// so you can't get in.  A document taped to the wall helpfully explains:
///
/// "Due to new security protocols, the password is locked in the safe below.
/// Please see the attached document for the new combination."
///
/// The safe has a dial with only an arrow on it; around the dial are the
/// numbers `0` through `99` in order.  As you turn the dial it makes a small
/// click noise as it reaches each number.
///
/// The attached document (your puzzle input) contains a sequence of
/// __rotations__, one per line, which tell you how to open the safe.
/// A rotation starts with an `L` or `R` which indicates whether the rotation
/// should be to the __left__ (toward lower numbers) or to the __right__
/// (toward higher numbers). Then, the rotation has a __distance__ value which
/// indicates how many clicks the dial should be rotated in that direction.
///
/// So, if the dial were pointing at `11`, a rotation of `R8` would cause the
/// dial to point at `19`.  After that, a rotation of `L19` would cause it to
/// point at `0`.
///
/// Because the dial is a circle, turning the dial __left__ from `0` one click
/// makes it point at `99`. Similarly, turning the dial __right__ from `99` one
/// click makes it point at `0`.
///
/// So, if the dial were pointing at `5`, a rotation of `L10` would cause it
/// to point at `95`.  After that, a rotation of `R5` could cause it
/// to point at `0`.
///
/// The dial starts by pointing at `50`.
///
/// You could follow the instructions, but your recent required official North
/// Pole secret entrance security training seminar taught you that the safe is
/// actually a decoy. The actual password is __the number of times the dial is
/// left pointing at `0` after any rotation in the sequence__.
///
/// For example, suppose the attached document contained the following rotations:
///
///     L68
///     L30
///     R48
///     L5
///     R60
///     L55
///     L1
///     L99
///     R14
///     L82
///
/// Following these rotations would cause the dial to move as follows:
///
/// - The dial starts by pointing at `50`.
/// - The dial is rotated `L68` to point at `82`.
/// - The dial is rotated `L30` to point at `52`.
/// - The dial is rotated `R48` to point at __`0`__.
/// - The dial is rotated `L5`  to point at `95`.
/// - The dial is rotated `R60` to point at `55`.
/// - The dial is rotated `L55` to point at __`0`__.
/// - The dial is rotated `L1`  to point at `99`.
/// - The dial is rotated `L99` to point at __`0`__.
/// - The dial is rotated `R14` to point at `14`.
/// - The dial is rotated `L82` to point at `32`.
///
/// Because the dial points at `0` a total of three times during this process,
/// the password in this example is `3`.
///
/// Analyze the rotations in your attached document. __What's the actual
/// password to open the door__?
///
/// # Part Two
///
/// You're sure that's the right password, but the door won't open.  You knock,
/// but nobody answers.  You build a snowman while you think.
///
/// As you're rolling the snowballs for your snowman, you find another security
/// document that must have fallen into the snow:
///
/// > Due to newer security protocols, please use __password method
/// > 0x434C49434B__ until further notice.
///
/// You remember from the training seminar that "method 0x434C49434B" means
/// you're actually supposed to count the number of times __any click__ causes
/// the dial to point at `0`, regardless of whether it happens during a
/// rotation or at the end of one.
///
/// Following the same rotations as in the above example, the dial points at
/// zero a few extra times during its rotations:
///
/// - The dial starts by pointing at 50.
/// - The dial is rotated `L68` to point at `82`;
///     during this rotation, it points at __`0`__ once.
/// - The dial is rotated `L30` to point at `52`.
/// - The dial is rotated `R48` to point at __`0`__.
/// - The dial is rotated `L5`  to point at `95`.
/// - The dial is rotated `R60` to point at `55`;
///     during this rotation, it points at __`0`__ once.
/// - The dial is rotated `L55` to point at __`0`__.
/// - The dial is rotated `L1`  to point at `99`.
/// - The dial is rotated `L99` to point at __`0`__.
/// - The dial is rotated `R14` to point at `14`.
/// - The dial is rotated `L82` to point at `32`;
///     during this rotation, it points at __`0`__ once.
///
/// In this example, the dial points at `0` three times at the end of a
/// rotation, plus three more times during a rotation. So, in this example, the
/// new password would be `6`.
///
/// Be careful: if the dial were pointing at `50`, a single rotation like
/// `R1000` would cause the dial to point at `0` ten times before returning
/// back to `50`!
///
/// Using password method 0x434C49434B,
/// __what is the password toopen the door?__


@main
struct SecretEntrance: AsyncParsableCommand
{
    /// Apply "password method 0x434C49434B," counting the number of times the
    /// dial "clicks" at `0`, whether it's during a rotation or at its end.
    @Flag(help: "Use password method `0x434C49434B`, counting each time the dial “clicks” at `0`, during a rotation, whether in passing or at its end.")
    var `method0x434c49434b`: Bool = false
}


// MARK: - Command Execution

extension SecretEntrance
{
    mutating func run() async throws
    {
        var dial = Dial()

        for try await line: String in URL(filePath: #filePath).deletingLastPathComponent().appending(path: "Input.txt").lines  // FileHandle.standardInput.bytes.lines
        {
            let       distanceIndex      : String.Index   = line.index(line.startIndex, offsetBy: Dial.Direction.rawLength)
            guard let directionCharacter : Character      = line.first                                  else { throw AteShit(whilst: .parsing, "Couldn't get first character of line.")}
            guard let direction          : Dial.Direction = .init(rawValue: String(directionCharacter)) else { throw AteShit(whilst: .parsing, "First character of line isn't a valid Direction: '\(line)'.")}
            guard let distance           : Int            = .init(line[distanceIndex...])               else { throw AteShit(whilst: .parsing, "Couldn't get distance value from line: '\(line)'.")}

            dial.rotate(direction, by: distance, counting: (self.method0x434c49434b ? .whenPassedOrSelected : .whenSelected))
        }

        print(dial.zeroCount)
    }
}


struct Dial
{
    /// The direction in which the dial will be rotated.
    enum Direction: String
    {
        /// The rotation will be to the right, or clockwise.
        case r = "R"
        /// The rotation will be to the left, or counterclockwise.
        case l = "L"

        /// The length of the raw value of all cases in this enum.  Useful when
        /// parsing command input for automated rotations... winky face.
        static let rawLength: Int = 1
    }


    enum CountingMode
    {
        /// ``self.zeroCount`` will be incremented if the dial "clicks" to `0`
        /// at the end of a rotation.
        case whenSelected

        /// ``self.zeroCount`` will be incremented whenever the dial "clicks"
        /// at `0`, whether in passing during a rotation or at its end.  This
        /// supports password method `0x434C49434B`.
        case whenPassedOrSelected
    }


    static let positions: ClosedRange<Int> = (0 ... 99)

    var position: Int = 50
    var zeroCount: Int = 0


    /// Rotates the dial with the specified direction, distance, and manner of
    /// counting the dial's interaction with `0`.
    mutating func rotate(_ direction: Direction, by distance: Int, counting: CountingMode = .whenSelected)
    {
        let startingPosition    : Int = self.position
        let fullRotationCount   : Int = (distance / Self.positions.count)
        let effectiveDistance   : Int = (distance - (Self.positions.count * fullRotationCount))
        let adjustedNewPosition : Int
        let rawNewPosition      : Int

        switch direction
        {
            case .r:
                rawNewPosition = (startingPosition + effectiveDistance)
                adjustedNewPosition = Self.positions.contains(rawNewPosition) ? rawNewPosition : (rawNewPosition - Self.positions.count)
            case .l:
                rawNewPosition = (startingPosition - effectiveDistance)
                adjustedNewPosition = Self.positions.contains(rawNewPosition) ? rawNewPosition : (rawNewPosition + Self.positions.count)
        }

        self.position = adjustedNewPosition

        // If we landed on zero, count a click.
        if ( adjustedNewPosition == Self.positions.lowerBound ) { self.zeroCount += 1 }

        // If we're only counting clicks when we land on zero, we're done.
        if ( counting != .whenPassedOrSelected ) { return }

        // Count a click for each full rotation of the dial.
        self.zeroCount += fullRotationCount

        // Avoid double-counting clicks for starting on zero (i.e., landed on
        // zero last rotation) or landing on zero this rotation.
        if [adjustedNewPosition, startingPosition].contains(Self.positions.lowerBound) { return }

        // If a left rotation's raw position exceededs the lower bound, or a
        // right rotation's raw position exceededs the upper bound, then we've
        // passed zero; count a click.
        if ( (direction == .r && rawNewPosition > Self.positions.upperBound) ||
             (direction == .l && rawNewPosition < Self.positions.lowerBound) ) { self.zeroCount += 1 }
    }
}


