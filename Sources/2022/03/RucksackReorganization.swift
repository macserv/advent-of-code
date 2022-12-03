//
//  RucksackReorganization.swift
//
//  Created by Matthew Judy on 2022-12-03.
//


import ArgumentParser
import Foundation
import Shared


/**
 Day 3: Rucksack Reorganization

 # Part One

 One Elf has the important job of loading all of the rucksacks with supplies
 for the jungle journey.

 * Each rucksack has two large compartments.
 * All items of a given type are meant to go into exactly one of the
    two compartments.

 Unfortunately, the Elf that did the packing failed to follow the second rule;

 * Each rucksack contains a single item type which has been placed into *both*
    compartments, and so a the items now need to be rearranged

 The Elves have made a list of all of the items currently in each rucksack
 (your puzzle input), but they need your help finding the errors.

 * The list of items for each rucksack is given as characters all on a
    single line.
 * Every item type is identified by a single lowercase or uppercase letter
    (that is, a and A refer to different types of items).
 * A given rucksack always has the same number of items in each of its two
    compartments:
    * The first half of the characters represent items in the first compartment.
    * The second half represent the second compartment.

 For example, suppose you have the following list of contents from
 six rucksacks:

 ```
 vJrwpWtwJgWrhcsFMMfFFhFp
 jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
 PmmdzqPrVvPwwTWBwg
 wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
 ttgJtRGJQctTZtZT
 CrZsJsPPZsGzwwsLwLmpwMDw
 ```

 * The first rucksack contains the items `vJrwpWtwJgWrhcsFMMfFFhFp`, which means:
    * its first compartment contains the items `vJrwpWtwJgWr`, while
    * the second compartment contains the items `hcsFMMfFFhFp`.
    * The only item type that appears in both compartments is lowercase `p`.

 * The second rucksack's compartments contain:
    * `jqHRNqRjqzjGDLGL` and
    * `rsFMfFZSrLrFZsSL`.
    * The only item type that appears in both compartments is uppercase `L`.

 * The third rucksack's compartments contain PmmdzqPrV and vPwwTWBwg;
    * the only common item type is uppercase `P`.

 * The fourth rucksack's compartments only share item type `v`.
 * The fifth rucksack's compartments only share item type `t`.
 * The sixth rucksack's compartments only share item type `s`.

 To help rearrange by importance, items can be given priorites as follows:

 * Lowercase item types a through z have priorities 1 through 26.
 * Uppercase item types A through Z have priorities 27 through 52.

 In the above example, the priority of the item type that appears in both
 compartments of each rucksack is:

 * 16 (p)
 * 38 (L)
 * 42 (P)
 * 22 (v)
 * 20 (t)
 * 19 (s)
 * Sum: 157

 Find the item type that appears in both compartments of each rucksack.

 What is the sum of the priorities of those item types?

 # Part Two

 As you finish identifying the misplaced items, the Elves come to you with
 another issue.

 For safety, the Elves are divided into groups of three. Every Elf carries a
 badge that identifies their group. For efficiency, within each group of three
 Elves, the badge is the only item type carried by all three Elves. That is, if
 a group's badge is item type B, then all three Elves will have item type B
 somewhere in their rucksack, and at most two of the Elves will be carrying any
 other item type.

 The problem is that someone forgot to put this year's updated authenticity
 sticker on the badges. All of the badges need to be pulled out of the
 rucksacks so the new authenticity stickers can be attached.

 Additionally, nobody wrote down which item type corresponds to each group's
 badges. The only way to tell which item type is the right one is by finding
 the one item type that is common between all three Elves in each group.

 Every set of three lines in your list corresponds to a single group, but each
 group can have a different badge item type. So, in the above example, the
 first group's rucksacks are the first three lines:

 ```
 vJrwpWtwJgWrhcsFMMfFFhFp
 jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
 PmmdzqPrVvPwwTWBwg
 ```

 In the first group, the only item type that appears in all three rucksacks is
 lowercase r; this must be their badges. The second group's rucksacks are the
 next three lines:

 ```
 wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
 ttgJtRGJQctTZtZT
 CrZsJsPPZsGzwwsLwLmpwMDw
 ```

 In the second group, their badge item type must be Z.

 Priorities for these items must still be found to organize the sticker
 attachment efforts: here, they are:

 * 18 (r) for the first group and
 * 52 (Z) for the second group.
 * The sum of these is 70.

 Find the item type that corresponds to the badges of each three-Elf group.
 What is the sum of the priorities of those item types?
 */
@main
struct RucksackReorganization: ParsableCommand
{
    enum SumPrioritiesOf: String, ExpressibleByArgument, CaseIterable
    {
        case duplicateItems
        case teamBadgeItems
    }

    @Option(help: "'duplicateItems' or 'teamBadgeItems'")
    var sumPrioritiesOf: SumPrioritiesOf
}


struct Rucksack
{
    struct Item: Hashable
    {
        static let priorities: [Character : Int] =
        {
            let itemIDsLow  = (UInt8(ascii: "a") ... UInt8(ascii: "z")).map { Character(UnicodeScalar($0)) }
            let itemIDsHigh = (UInt8(ascii: "A") ... UInt8(ascii: "Z")).map { Character(UnicodeScalar($0)) }

            return Dictionary(uniqueKeysWithValues: zip((itemIDsLow + itemIDsHigh), (1 ... 52)))
        }()

        let identifier: Character
        let priority: Int

        init(identifier: Character)
        {
            guard let priority = Item.priorities[identifier] else { fatalError() }

            self.identifier = identifier
            self.priority = priority
        }
    }


    let storage: (left: [Item], right: [Item])


    init(list: String)
    {
        let half = (list.count / 2)
        let leftList = list.prefix(half)
        let rightList = list.suffix(half)

        self.storage = (left: leftList.map(Item.init), right: rightList.map(Item.init) )
    }


    var itemsPresentInBothCompartments: Set<Item>
    {
        return Set(storage.left).intersection(Set(storage.right))
    }


    var allItems: [Item]
    {
        return (storage.left + storage.right)
    }
}


// MARK: - Command Execution

extension RucksackReorganization
{
    mutating func run() throws
    {
        switch self.sumPrioritiesOf
        {
            case .duplicateItems: try self.calculateSumOfDuplicateItemPriorities()
            case .teamBadgeItems: try self.calculateSumOfTeamBadgeItemPriorities()
        }
    }


    func calculateSumOfDuplicateItemPriorities() throws
    {
        var sumOfDuplicateItemPriorities = 0

        while let inputLine = readLine()
        {
            let sack = Rucksack(list: inputLine)

            let duplicates = sack.itemsPresentInBothCompartments
            let duplicatesSum = duplicates.map(\.priority).sum()

            sumOfDuplicateItemPriorities += duplicatesSum
        }

        print(sumOfDuplicateItemPriorities)
    }


    func calculateSumOfTeamBadgeItemPriorities() throws
    {
        let teamSize = 3
        var teamRucksacks: [Rucksack] = []
        var sumOfBadgePriorities = 0

        while let inputLine = readLine()
        {
            teamRucksacks.append(Rucksack(list: inputLine))

            if ( teamRucksacks.count < teamSize ) { continue }

            let inventories = teamRucksacks.map(\.allItems)
            let commonItems = inventories[1...].reduce(Set(inventories[0]))
            {
                return $0.intersection($1)
            }

            guard let badgeItem = commonItems.first else { fatalError() }

            sumOfBadgePriorities += badgeItem.priority
            teamRucksacks = []
        }

        print(sumOfBadgePriorities)
    }
}
