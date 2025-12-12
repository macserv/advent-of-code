//
//  Lobby.swift
//  AdventOfCode
//
//  Created by Matthew Judy on 2025-12-11.
//


import Foundation
import ArgumentParser
import AdventKit


/// Day 3 : Lobby
///
/// # Part One
///
/// You descend a short staircase, enter the surprisingly vast lobby, and are
/// quickly cleared by the security checkpoint.  When you get to the main
/// elevators, however, you discover that each one has a red light above it:
/// they're all __offline__.
///
/// "Sorry about that," an Elf apologizes as she tinkers with a nearby control
/// panel.  "Some kind of electrical surge seems to have fried them.  I'll try
/// to get them online soon."
///
/// You explain your need to get further underground.  "Well, you could at
/// least take the escalator down to the printing department, not that you'd
/// get much further than that without the elevators working.  That is, you
/// could if the escalator weren't also offline."
///
/// "But, don't worry!  It's not fried; it just needs power.  Maybe you can get
/// it running while I keep working on the elevators."
///
/// There are batteries nearby that can supply emergency power to the escalator
/// for just such an occasion.  The batteries are each labeled with their
/// [joltage](https://adventofcode.com/2020/day/10) rating, a value from
/// `1` to `9`.  You make a note of their joltage ratings (your puzzle input).
/// For example:
///
///     987654321111111
///     811111111111119
///     234234234234278
///     818181911112111
///
/// The batteries are arranged into __banks__; each line of digits in your
/// input corresponds to a single bank of batteries.  Within each bank, you
/// need to turn on __exactly two__ batteries; the joltage that the bank
/// produces is equal to the number formed by the digits on the batteries
/// you've turned on.  For example, if you have a bank like `12345` and you
/// turn on batteries `2` and `4`, the bank would produce `24` jolts.  (You
/// cannot rearrange batteries.)
///
/// You'll need to find the largest possible joltage each bank can produce.
/// In the above example:
///
/// * You can make the largest joltage possible, `98`, by turning on the first
///   two batteries.
/// * You can make the largest joltage possible by turning on the batteries
///   labeled `8` and `9`, producing 89 jolts.
/// * You can make `78` by turning on the last two batteries (marked
///   `7` and `8`).
/// * The largest joltage you can produce is `92`.
///
/// The total output joltage is the sum of the maximum joltage from each
/// bank, so in this example, the total output joltage is
/// `98 + 89 + 78 + 92` = `357`.
///
/// There are many batteries in front of you.  Find the maximum joltage
/// possible from each bank; __what is the total output joltage?__
///
/// # Part Two
///
/// The escalator doesn't move.  The Elf explains
/// that it probably needs more joltage to overcome the
/// [static friction](https://en.wikipedia.org/wiki/Static_friction)
/// of the system and hits the big red "joltage limit safety override" button.
/// You lose count of the number of times she needs to confirm "yes, I'm sure,"
/// and decorate the lobby a bit while you wait.
///
/// Now, you need to make the largest joltage by turning on __exactly twelve__
/// batteries within each bank.
///
/// The joltage output for the bank is still the number formed by the digits of
/// the batteries you've turned on; the only difference is that now there will
/// be `12` digits in each bank's joltage output instead of two.
///
/// Consider again the example from before.  Now, the joltages are much larger:
///
/// * In `987654321111111`, the largest joltage can be found by turning on
///   everything except some `1`s at the end to produce `987654321111`.
/// * In the digit sequence `811111111111119`, the largest joltage can be found
///   by turning on everything except some `1`s, producing `811111111119`.
/// * In `234234234234278`, the largest joltage can be found by turning on
///   everything except a `2` battery, a `3` battery, and another `2` battery
///   near the start to produce `434234234278`.
/// * In `818181911112111`, the joltage `888911112111` is produced by turning
///   on everything except some `1`s near the front.
/// * The total output joltage is now much larger:
///   `987654321111 + 811111111119 + 434234234278 + 888911112111 = 3121910778619`.
///
/// __What is the new total output joltage?__
///
@main
struct Lobby: AsyncParsableCommand
{
    @Option(help: "The number of batteries in each bank which can be used to create a combined joltage.")
    var batteriesPerBank: Int
}


// MARK: - Command Execution

extension Lobby
{
    mutating func run() async throws
    {
        let input: AsyncLineSequence = URL(filePath: #filePath).deletingLastPathComponent().appending(path: "Input.txt").lines
        let totalJoltage = try await input.reduce(into: UInt(0))
        {
            // Convert each character to an integer digit.
            let bankJoltages: [UInt] = $1.map { UInt(String($0))! }

            // Use a stack to maximize the joltage by removing the weakest digits strategically
            var stack = [UInt]()
            var removalsLeft = bankJoltages.count - self.batteriesPerBank

            for joltage in bankJoltages
            {
                while ( (false == stack.isEmpty)
                        && (stack.last! < joltage)
                        && removalsLeft > 0 )
                {
                    stack.removeLast()
                    removalsLeft -= 1
                }

                stack.append(joltage)
            }

            // If removals are still needed, remove from the end.
            while (removalsLeft > 0)
            {
                stack.removeLast()
                removalsLeft -= 1
            }

            // Multiply each digit by its magnitude to get the bank's joltage.
            let bankJoltage = stack.reduce(0) { ($0 * 10) + $1 }

            print(bankJoltage)

            $0 += bankJoltage
        }

        print(totalJoltage)
    }
}

