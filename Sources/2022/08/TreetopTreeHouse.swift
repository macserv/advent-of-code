//
//  TreetopTreeHouse.swift
//
//  Created by Matthew Judy on 2021-01-04.
//


import ArgumentParser
import Foundation
import AdventKit


/**
 Day 8 : Treetop Tree House

 # Part One

 The expedition comes across a peculiar patch of tall trees all planted
 carefully in a grid. The Elves explain that a previous expedition planted
 these trees as a reforestation effort. Now, they're curious if this would be a
 good location for a tree house.

 First, determine whether there is enough tree cover here to keep a tree
 house **hidden**. To do this, you need to count the number of trees that are
 **visible from outside the grid** when looking directly along a row or column.

 The Elves have already launched a quadcopter to generate a map with the height
 of each tree (your puzzle input). For example:

 ```
 30373
 25512
 65332
 33549
 35390
 ```

 Each tree is represented as a single digit whose value is its height, where
 `0` is the shortest and `9` is the tallest.

 A tree is **visible** if all of the other trees between it and an edge of the
 grid are **shorter** than it. Only consider trees in the same row or column;
 that is, only look up, down, left, or right from any given tree.

 All of the trees around the edge of the grid are **visible** - since they are
 already on the edge, there are no trees to block the view. In this example,
 that only leaves the interior nine trees to consider:

 The top-left 5 is visible from the left and top. (It isn't visible from the
 right or bottom since other trees of height 5 are in the way.)

 * The top-middle 5 is visible from the top and right.
 * The top-right 1 is not visible from any direction; for it to be visible,
    there would need to only be trees of height 0 between it and an edge.
 * The left-middle 5 is visible, but only from the right.
 * The center 3 is not visible from any direction; for it to be visible, there
    would need to be only trees of at most height 2 between it and an edge.
 * The right-middle 3 is visible from the right.
 * In the bottom row, the middle 5 is visible, but the 3 and 4 are not.

 With 16 trees visible on the edge and another 5 visible in the interior, a total of 21 trees are visible in this arrangement.

 Consider your map; how many trees are visible from outside the grid?

 # Part Two


 Content with the amount of tree cover available, the Elves just need to know
 the best spot to build their tree house: they would like to be able to see
 a lot of **trees**.

 To measure the viewing distance from a given tree, look up, down, left, and
 right from that tree; stop if you reach an edge or at the first tree that is
 the same height or taller than the tree under consideration. (If a tree is
 right on the edge, at least one of its viewing distances will be zero.)

 The Elves don't care about distant trees taller than those found by the rules
 above; the proposed tree house has large eaves to keep it dry, so they wouldn't
 be able to see higher than the tree house anyway.

 In the example above, consider the middle `5` in the second row:

 ```
 30373
 25512 <-- the centered `5`
 65332
 33549
 35390
 ```

 * Looking up, its view is not blocked; it can see `1` tree (of height `3`).
 * Looking left, its view is blocked immediately; it can see only `1` tree
    (of height `5`, right next to it).
 * Looking right, its view is not blocked; it can see `2` trees.
 * Looking down, its view is blocked eventually; it can see `2` trees
    (one of height `3`, then the tree of height `5` that blocks its view).

 A tree's **scenic score** is found by **multiplying together** its viewing
 distance in each of the four directions. For this tree, this is `4`
 (found by multiplying `1 * 1 * 2 * 2`).

 However, you can do even better: consider the tree of height `5` in the middle of the fourth row:

 ```
 30373
 25512
 65332
 33549 <-- the centered `5`
 35390
 ```

 * Looking up, its view is blocked at `2` trees
    (by another tree with a height of 5).
 * Looking left, its view is not blocked; it can see `2` trees.
 * Looking down, its view is also not blocked; it can see `1` tree.
 * Looking right, its view is blocked at `2` trees
    (by a massive tree of height 9).
 
 This tree's scenic score is `8` (`2 * 2 * 1 * 2`); this is the ideal spot for
 the tree house.

 Consider each tree on your map.  **What is the highest scenic score possible
 for any tree?**
**/
@main
struct TreetopTreeHouse: AsyncParsableCommand
{
    /// Enumeration for argument which activates "Part Two" behavior
    enum Mode: String, ExpressibleByArgument, CaseIterable
    {
        case visibleTreeCount
        case bestScenicScore
    }

    @Option(help: "'visibleTreeCount' or 'bestScenicScore'")
    var mode: Mode
}


typealias Tree = (height: Int, visible: Bool)


extension Sequence where Element : Collection
{
    subscript(column column : Element.Index) -> [ Element.Iterator.Element ]
    {
        return map { $0[ column ] }
    }
}


// MARK: - Command Execution

extension TreetopTreeHouse
{
    func evaluateHeights<Result>(rows: [[Int]], columns: [[Int]], edgeValue: Result, reduceInto startValue: Result, evaluation: ((_ result: Result, _ info: (directionalTrees: [Int], height: Int)) -> Result)) -> [[Result]]
    {
        return rows.enumerated().map
        {
            (rowIndex, row) in

            if ( (rowIndex == 0) || (rowIndex == rows.lastIndex) )
            {
                return Array(repeating: edgeValue, count: columns.count)
            }

            return row.enumerated().map
            {
                (columnIndex, height) in

                if ( (columnIndex == 0) || (columnIndex == columns.lastIndex) )
                {
                    return edgeValue
                }

                // We're now evaluating an "inner" tree, which may not be visible.
                // Look around and evaluate based on our surroundings.
                let column = columns[columnIndex]
                return [
                    (Array<Int>(row[..<columnIndex].reversed()),  height),  // leftward
                    (Array<Int>(row[columnIndex...].dropFirst()), height), // rightward
                    (Array<Int>(column[..<rowIndex].reversed()),  height),  // upward
                    (Array<Int>(column[rowIndex...].dropFirst()), height), // downward
                ].reduce(startValue, evaluation)
            }
        }
    }


    mutating func run() async throws
    {
        let input   : AsyncLineSequence = FileHandle.standardInput.bytes.lines
        let rows    : [[Int]]           = try await input.reduce(into: [[Int]]()) { $0.append($1.integers) }
        let columns : [[Int]]           = rows[0].enumerated().map { rows[column: $0.0] }

        switch self.mode
        {
            case .visibleTreeCount:
                let visibilityGrid = self.evaluateHeights(rows: rows, columns: columns, edgeValue: true, reduceInto: false)
                {
                    result, info in
                    return ( result || (info.directionalTrees.firstIndex { $0 >= info.height } == nil) )
                }
                print(visibilityGrid.reduce(0) { ($0 + $1.count { $0 }) })

            case .bestScenicScore:
                let scoreGrid = self.evaluateHeights(rows: rows, columns: columns, edgeValue: 0, reduceInto: 1)
                {
                    result, info in
                    return ( result * ( (info.directionalTrees.firstIndex { $0 >= info.height } ?? (info.directionalTrees.count - 1)) + 1 ) )
                }
                print(scoreGrid.joined().max()!)
        }
    }
}
