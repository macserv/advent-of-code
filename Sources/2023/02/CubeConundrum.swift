//
//  CubeConundrum.swift
//
//  Created by Matthew Judy on 2023-12-05.
//


import ArgumentParser
import Foundation
import Shared


/// Day 2 : Cube Conundrum
///
/// # Part One
///
/// You're launched high into the atmosphere! The apex of your trajectory just
/// barely reaches the surface of a large island floating in the sky.
/// You gently land in a fluffy pile of leaves. It's quite cold, but you don't
/// see much snow. An Elf runs over to greet you.
///
/// The Elf explains that you've arrived at **Snow Island** and apologizes for
/// the lack of snow. He'll be happy to explain the situation, but it's a bit
/// of a walk, so you have some time. They don't get many visitors up here;
/// would you like to play a game in the meantime?
///
/// As you walk, the Elf shows you a small bag and some cubes which are either
/// red, green, or blue. Each time you play this game, he will hide a secret
/// number of cubes of each color in the bag, and your goal is to figure out
/// information about the number of cubes.
///
/// To get information, once a bag has been loaded with cubes, the Elf will
/// reach into the bag, grab a handful of random cubes, show them to you, and
/// then put them back in the bag. He'll do this a few times per game.
///
/// You play several games and record the information from each game (your
/// puzzle input). Each game is listed with its ID number (like the `11` in
/// `Game 11: ...`) followed by a semicolon-separated list of subsets of cubes
/// that were revealed from the bag (like `3 red, 5 green, 4 blue`).
///
/// For example, the record of a few games might look like this:
///
/// ```
/// Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
/// Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
/// Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
/// Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
/// Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
/// ```
///
/// In game 1, three sets of cubes are revealed from the bag (and then put back
/// again). The first set is 3 blue cubes and 4 red cubes; the second set is
/// 1 red cube, 2 green cubes, and 6 blue cubes; the third set is only
/// 2 green cubes.
///
/// The Elf would first like to know which games would have been possible if
/// the bag contained **only 12 red cubes, 13 green cubes, and 14 blue cubes**?
///
/// In the example above, games 1, 2, and 5 would have been **possible** if
/// the bag had been loaded with that configuration. However, game 3 would have
/// been **impossible** because at one point the Elf showed you 20 red cubes
/// at once; similarly, game 4 would also have been impossible because the Elf
/// showed you 15 blue cubes at once. If you add up the IDs of the games that
/// would have been possible, you get **`8`**.
///
/// Determine which games would have been possible if the bag had been loaded
/// with only 12 red cubes, 13 green cubes, and 14 blue cubes. **What is the
/// sum of the IDs of those games?**
///
/// # Part Two
///
/// The Elf says they've stopped producing snow because they aren't getting any
/// **water**! He isn't sure why the water stopped; however, he can show you
/// how to get to the water source to check it out for yourself. It's just
/// up ahead!
///
/// As you continue your walk, the Elf poses a second question: in each game
/// you played, what is the **fewest number of cubes of each color** that could
/// have been in the bag to make the game possible?
///
/// Again consider the example games from earlier.
///
/// * In game 1, the game could have been played with as few as 4 red, 2 green,
///     and 6 blue cubes. If any color had even one fewer cube, the game would
///     have been impossible.
/// * Game 2 could have been played with a minimum of 1 red, 3 green, and
///     4 blue cubes.
/// * Game 3 must have been played with at least 20 red, 13 green, and
///     6 blue cubes.
/// * Game 4 required at least 14 red, 3 green, and 15 blue cubes.
/// * Game 5 needed no fewer than 6 red, 3 green, and 2 blue cubes in the bag.
///
/// The **power** of a set of cubes is equal to the numbers of red, green,
/// and blue cubes multiplied together. The power of the minimum set of cubes
/// in game 1 is `48`. In games 2-5 it was `12`, `1560`, `630`, and `36`,
/// respectively. Adding up these five powers produces the sum `2286`.
///
/// For each game, find the minimum set of cubes that must have been present.
/// **What is the sum of the power of these sets?**
///
@main
struct CubeConundrum: AsyncParsableCommand
{
    /// Enumeration for argument which activates "Part Two" behavior
    enum Mode: String, ExpressibleByArgument, CaseIterable
    {
        case sumOfGameIDs
        case sumOfGamePowers
    }

    @Option(help: "'sumOfGameIDs' or 'sumOfGamePowers'")
    var mode: Mode = .sumOfGamePowers
}


struct Grab
{
    let redCubes   : Int
    let greenCubes : Int
    let blueCubes  : Int

    func isPossible(for loadout: Grab) -> Bool
    {
        [\Grab.redCubes, \Grab.greenCubes, \Grab.blueCubes]
            .reduce(true) {
                $0 && (loadout[keyPath: $1] >= self[keyPath: $1])
            }
    }
}


extension Grab
{
    /// Initialize with segment of input line
    /// - Parameter input: input line representing a single grab,
    ///     e.g., `1 green, 3 red, 6 blue`
    init(input: String) throws
    {
        var inputRed   = 0
        var inputGreen = 0
        var inputBlue  = 0

        try input.components(separatedBy: ", ").forEach
        {
            guard case let gemInfo = $0.components(separatedBy: " "), (gemInfo.count == 2),
                       let gemCount: Int = Int(gemInfo[0]),
                  case let gemColor: String = gemInfo[1]
            else { throw AteShit(whilst: .parsing, input) }

            switch gemColor
            {
                case "red"   : inputRed   = gemCount
                case "green" : inputGreen = gemCount
                case "blue"  : inputBlue  = gemCount
                default: throw AteShit(whilst: .parsing, input)
            }
        }

        self = Grab(redCubes: inputRed, greenCubes: inputGreen, blueCubes: inputBlue)
    }
}


struct Game
{
    let id    : Int
    let grabs : [Grab]

    var maxRed     : Int  { self.grabs.map(\.redCubes)  .max() ?? 0 }
    var maxGreen   : Int  { self.grabs.map(\.greenCubes).max() ?? 0 }
    var maxBlue    : Int  { self.grabs.map(\.blueCubes) .max() ?? 0 }
    var minLoadout : Grab { Grab(redCubes: self.maxRed, greenCubes: self.maxGreen, blueCubes: self.maxBlue ) }

    func isPossible(for loadout: Grab) -> Bool
    {
        self.grabs.first { $0.isPossible(for: loadout) == false } == nil
    }

    /// Initialize with a full input line
    /// - Parameter input: input line representing a full game with multiple
    ///     grabs, e.g., `Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green`
    init(input: String) throws
    {
        guard case let inputSections : [String] = input.components(separatedBy: ": "), (inputSections.count == 2),
                   let gameID        : Int      = Int(inputSections[0].components(separatedBy: " ")[1]),
              case let grabInputs    : [String] = inputSections[1].components(separatedBy: "; "),  (grabInputs.count > 0)
        else { throw AteShit(whilst: .parsing, input) }

        self.id    = gameID
        self.grabs = try grabInputs.reduce(into: []) { $0.append(try Grab(input: $1)) }
    }
}

// MARK: - Command Execution

extension CubeConundrum
{
    mutating func run() async throws
    {
        let input   : AsyncLineSequence = FileHandle.standardInput.bytes.lines
        let loadout : Grab              = Grab(redCubes: 12, greenCubes: 13, blueCubes: 14)
        let output  : Int               = try await input.reduce(0)
        {
            let game : Game = try Game(input: $1)
            
            switch self.mode
            {
                case .sumOfGameIDs:
                    return if game.isPossible(for: loadout) { $0 + game.id } else { $0 }

                case .sumOfGamePowers:
                    return ( $0 + (game.minLoadout.redCubes * game.minLoadout.greenCubes * game.minLoadout.blueCubes) )
            }
        }

        print(output)
    }
}

