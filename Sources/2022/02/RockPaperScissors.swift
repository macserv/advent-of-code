//
//  RockPaperScissors.swift
//
//  Created by Matthew Judy on 2022-12-02.
//


import ArgumentParser
import Foundation
import Shared


/**
 Day 2: Rock Paper Scissors

 # Part One

 The Elves begin to set up camp on the beach. To decide whose tent gets to be
 closest to the snack storage, a giant Rock Paper Scissors tournament is
 already in progress.

 Rock Paper Scissors is a game between two players. Each game contains many
 rounds; in each round, the players each simultaneously choose one of Rock,
 Paper, or Scissors using a hand shape. Then, a winner for that round is
 selected:

    * Rock defeats Scissors
    * Scissors defeats Paper
    * Paper defeats Rock.

 If both players choose the same shape, the round instead ends in a draw.

 Appreciative of your help yesterday, one Elf gives you an encrypted strategy
 guide (your puzzle input) that they say will be sure to help you win:

 > "The first column is what your opponent is going to play:
 >    A for Rock, B for Paper, and C for Scissors. The second column--"

 Suddenly, the Elf is called away to help with someone's tent.

 The second column, you reason, must be what you should play in response:

 * X for Rock
 * Y for Paper
 * Z for Scissors

 Winning every time would be suspicious, so the responses must have been
 carefully chosen.

 The winner of the whole tournament is the player with the highest score. Your
 total score is the sum of your scores for each round. The score for a single
 round is the score for the shape you selected:

 * (1 for Rock, 2 for Paper, and 3 for Scissors)

 plus the score for the outcome of the round:

 * (0 if you lost, 3 if the round was a draw, and 6 if you won).

 Since you can't be sure if the Elf is trying to help you or trick you, you
 should calculate the score you would get if you were to follow the
 strategy guide.

 For example, suppose you were given the following strategy guide:

 ```
 A Y
 B X
 C Z
 ```

 This strategy guide predicts and recommends the following:

 * In the first round, your opponent will choose Rock (A).
    * You should choose Paper (Y).
    * This ends in a win for you with a score of 8:
        * (2 because you chose Paper + 6 because you won).

 * In the second round, your opponent will choose Paper (B).
    * You should choose Rock (X).
    * This ends in a loss for you with a score of 1 (1 + 0).

 * The third round is a draw with both players choosing Scissors.
    * This gives you a score of 3 + 3 = 6.

 In this example, if you were to follow the strategy guide, you would get a
 total score of 15 (8 + 1 + 6).

 What would your total score be if everything goes exactly according to your strategy guide?

 # Part Two

 The Elf finishes helping with the tent and sneaks back over to you.

 > "Anyway, the second column says how the round needs to end:
    X means you need to lose,
    Y means you need to end the round in a draw, and
    Z means you need to win. Good luck!"

 The total score is still calculated in the same way, but now you need to
 figure out what shape to choose so the round ends as indicated. The example
 above now goes like this:

 * In the first round, your opponent will choose Rock (A).
    * You need the roundto end in a draw (Y), so you also choose Rock.
    * This gives you a score of 1 + 3 = 4.

 * In the second round, your opponent will choose Paper (B).
    * You choose Rock so you lose (X) with a score of 1 + 0 = 1.

 * In the third round, you will defeat your opponent's Scissors
    * with Rock for a score of 1 + 6 = 7.

 Now that you're correctly decrypting the ultra top secret strategy guide, you
 would get a total score of 12.

 Following the Elf's instructions for the second column, what would your total
 score be if everything goes exactly according to your strategy guide?
 */
@main
struct RockPaperScissors: ParsableCommand
{
    enum MoveInterpretation: String, ExpressibleByArgument, CaseIterable
    {
        case hand
        case outcome
    }

    @Option(help: "Specifies how your move identifier (X, Y, Z) should be interpreted: as a 'hand' (rock, paper, scissors) or an 'outcome' (loss, draw, win).")
    var moveInterpretation: MoveInterpretation
}


enum Hand: Int, Comparable, CaseIterable
{
    case rock     = 1
    case paper    = 2
    case scissors = 3

    init(_ identifier: String)
    {
        switch identifier
        {
            case "A", "X" : self = .rock
            case "B", "Y" : self = .paper
            case "C", "Z" : self = .scissors
            default       : fatalError()
        }
    }

    var label: String
    {
        switch self
        {
            case .rock     : return "    Rock"
            case .paper    : return "   Paper"
            case .scissors : return "Scissors"
        }
    }

    private static let weakOpponentMap   = Dictionary(uniqueKeysWithValues: zip(Hand.allCases, Hand.allCases.rotatedRight(by: 1)))
    private static let strongOpponentMap = Dictionary(uniqueKeysWithValues: zip(Hand.allCases, Hand.allCases.rotatedLeft (by: 1)))

    var weakOpponent   : Hand { Hand.weakOpponentMap[self]! }
    var strongOpponent : Hand { Hand.strongOpponentMap[self]! }

    static func < (lhs: Hand, rhs: Hand) -> Bool
    {
        lhs == rhs.weakOpponent
    }
}


struct Match
{
    enum Outcome: Int
    {
        case loss = 0
        case draw = 3
        case win  = 6

        init(_ identifier: String)
        {
            switch identifier
            {
                case "X" : self = .loss
                case "Y" : self = .draw
                case "Z" : self = .win
                default       : fatalError()
            }
        }

        var label: String
        {
            switch self
            {
                case .loss : return "Lose"
                case .draw : return "Draw"
                case .win  : return "Win!"
            }
        }

    }


    var score: Int


    init(opponentHand: Hand, playerHand: Hand)
    {
        let outcome: Outcome =
        {
            switch (opponentHand, playerHand)
            {
                case _ where (opponentHand >  playerHand) : return .loss
                case _ where (opponentHand == playerHand) : return .draw
                default                                   : return .win
            }
        }()

        self.score = (playerHand.rawValue + outcome.rawValue)

        print("\(opponentHand.label) vs. \(playerHand.label) (+ \(playerHand.rawValue)): \(outcome.label) (+ \(outcome.rawValue)).  Score: \(self.score).  ", terminator: "")
    }


    init(opponentHand: Hand, outcome: Outcome)
    {
        let playerHand: Hand =
        {
            switch outcome
            {
                case .loss : return opponentHand.weakOpponent
                case .draw : return opponentHand
                case .win  : return opponentHand.strongOpponent
            }
        }()

        self.score = (playerHand.rawValue + outcome.rawValue)

        print("Against \(opponentHand.label), \(outcome.label) (+\(outcome.rawValue)) with \(playerHand.label) (+\(playerHand.rawValue)).  Score: \(self.score).  ", terminator: "")
    }


    init(matchInput: String, interpretation: RockPaperScissors.MoveInterpretation)
    {
        let identifiers = matchInput.split(separator: " ").map(String.init)

        switch interpretation
        {
            case .hand    : self.init( opponentHand: Hand(identifiers[0]), playerHand: Hand(identifiers[1]) )
            case .outcome : self.init( opponentHand: Hand(identifiers[0]), outcome:    Outcome(identifiers[1]) )
        }
    }
}


extension RockPaperScissors
{
    mutating func run() throws
    {
        var total: Int = 0

        while let matchInput = readLine()
        {
            let score: Int = Match(matchInput: matchInput, interpretation: self.moveInterpretation).score
            total += score
            print("Total: \(total)")
        }
    }
}

