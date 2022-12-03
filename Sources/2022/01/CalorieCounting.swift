//
//  CalorieCounting.swift
//
//  Created by Matthew Judy on 2022-12-01.
//


import ArgumentParser
import Foundation
import Shared


/**
 Day 1: Calorie Counting

 ## Part One

 The jungle must be too overgrown and difficult to navigate in vehicles or
 access from the air; the Elves' expedition traditionally goes on foot. As your
 boats approach land, the Elves begin taking inventory of their supplies. One
 important consideration is food - in particular, the number of Calories each
 Elf is carrying (your puzzle input).

 The Elves take turns writing down the number of Calories contained by the
 various meals, snacks, rations, etc. that they've brought with them, one item
 per line. Each Elf separates their own inventory from the previous Elf's
 inventory (if any) by a blank line.

 For example, suppose the Elves finish writing their items' Calories and end up
 with the following list:

 ```
 1000
 2000
 3000

 4000

 5000
 6000

 7000
 8000
 9000

 10000
 ```

 This list represents the Calories of the food carried by five Elves:

 * The first Elf is carrying food with 1000, 2000, and 3000 Calories, a total
   of 6000 Calories.
 * The second Elf is carrying one food item with 4000 Calories.
 * The third Elf is carrying food with 5000 and 6000 Calories, a total of
   11000 Calories.
 * The fourth Elf is carrying food with 7000, 8000, and 9000 Calories, a total
   of 24000 Calories.
 * The fifth Elf is carrying one food item with 10000 Calories.

 In case the Elves get hungry and need extra snacks, they need to know which Elf
 to ask: they'd like to know how many Calories are being carried by the Elf
 carrying the most Calories. In the example above, this is 24000 (carried by
 the fourth Elf).

 Find the Elf carrying the most Calories. How many total Calories is that
 Elf carrying?

 ## Part Two

 By the time you calculate the answer to the Elves' question, they've already
 realized that the Elf carrying the most Calories of food might eventually run
 out of snacks.

 To avoid this unacceptable situation, the Elves would instead like to know the
 total Calories carried by the top three Elves carrying the most Calories.
 That way, even if one of those Elves runs out of snacks, they still have
 two backups.

 In the example above, the top three Elves are the fourth Elf (with 24000
 Calories), then the third Elf (with 11000 Calories), then the fifth Elf (with
 10000 Calories). The sum of the Calories carried by these three elves is 45000.

 Find the top three Elves carrying the most Calories. How many Calories are
 those Elves carrying in total?
*/
@main
struct CalorieCounting: ParsableCommand
{
    @Option(help: "The number of elves (sorted by their inventory's caloric content) to aggregate for the result.")
    var top: Int = 1

    mutating func validate() throws
    {
        guard self.top >= 1 else { throw ValidationError("Please specify a 'top' of at least 1.") }
    }
}


struct Edible
{
    let calories: Int
}


struct Elf
{
    var inventory         : [Edible]
    var availableCalories : Int { inventory.map(\.calories).sum() }
}


extension CalorieCounting
{
    mutating func run() throws
    {
        var elves     : [Elf]    = []
        var inventory : [Edible] = []

        while let entry = readLine()
        {
            if ( entry.isEmpty )
            {
                elves.append(Elf(inventory: inventory))
                inventory = []
                continue
            }

            guard let calories = Int(entry) else { fatalError("A non-integer value was encountered.") }

            inventory.append(Edible(calories: calories))
        }

        elves.append(Elf(inventory: inventory))

        let topElves = elves.sorted(by: { $0.availableCalories > $1.availableCalories })[0...(self.top - 1)]
        let totalCalories = topElves.map(\.availableCalories).sum()

        print(totalCalories)
    }
}

